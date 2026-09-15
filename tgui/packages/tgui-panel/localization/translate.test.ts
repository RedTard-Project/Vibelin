import { beforeEach, describe, expect, it } from 'bun:test';

import {
  isActive,
  loadDeclensions,
  loadDictionary,
  resetDeclensions,
  setLang,
  translateText,
} from './translate';

const DICTIONARY = {
  version: 1,
  nouns: {
    'throat': { nom: 'горло', gen: 'горла', acc: 'горло' },
    'left arm': { nom: 'левая рука', gen: 'левой руки', acc: 'левую руку' },
    'sword': { nom: 'меч', gen: 'меча', acc: 'меч' },
  },
  fragments: {
    'Armor stops the damage.': 'Броня поглощает урон.',
    'SNEAK ATTACK!': 'АТАКА ИСПОДТИШКА!',
  },
  patterns: [
    // specific before generic, exactly as strings/patterns.txt orders them
    { re: '^(.+?) slashed themself!$', ru: '$1 ранит себя!' },
    { re: '^I slash myself!$', ru: 'Я раню себя!' },
    { re: "^(.+?) slashed (.+?)!$", ru: '$1 рубит $2|acc!' },
    { re: '^I slash (.+?)!$', ru: 'Я рублю $1|acc!' },
    { re: "^(.+?) bites (.+?)'s (.+?)!$", ru: '$1 кусает $3|acc $2|gen!' },
    { re: "^dodges (.+?)'s attack!$", ru: 'уклоняется от атаки $1|gen!' },
    { re: '^(.+?) draws (.+?)!$', ru: '$1 достаёт $2|acc!' },
    { re: '^BROKEN(', ru: 'never' },
  ],
};

const ALDRIC = { gen: 'сира Альдрика', acc: 'сира Альдрика' };
const IVAN = { gen: 'Ивана', acc: 'Ивана' };

describe('chat translation', () => {
  beforeEach(() => {
    resetDeclensions();
    loadDictionary(DICTIONARY as never);
    setLang('ru');
    loadDeclensions({ 'Sir Aldric': ALDRIC, 'Ivan': IVAN });
  });

  it('is inactive until a dictionary is loaded', () => {
    expect(isActive()).toBe(true);
  });

  it('translates an exact fragment', () => {
    expect(translateText('SNEAK ATTACK!')).toBe('АТАКА ИСПОДТИШКА!');
  });

  it('preserves the padding fragments carry', () => {
    expect(translateText(' Armor stops the damage.')).toBe(
      ' Броня поглощает урон.',
    );
  });

  it('declines names captured from a pattern', () => {
    expect(translateText('Sir Aldric slashed Ivan!')).toBe(
      'Sir Aldric рубит Ивана!',
    );
  });

  it('falls back to the raw capture when a name has no declensions', () => {
    expect(translateText('Sir Aldric slashed Goblin!')).toBe(
      'Sir Aldric рубит Goblin!',
    );
  });

  it('declines closed-set nouns and reorders captures', () => {
    expect(translateText("Sir Aldric bites Ivan's throat!")).toBe(
      'Sir Aldric кусает горло Ивана!',
    );
  });

  it('matches a fragment that a tag split off its subject', () => {
    expect(translateText(" dodges Sir Aldric's attack!")).toBe(
      ' уклоняется от атаки сира Альдрика!',
    );
  });

  it('leaves text the dictionary does not cover alone', () => {
    expect(translateText('The door slides open.')).toBe('The door slides open.');
  });

  // DM writes items both bare and through \a / \the, and a sentence-initial
  // article arrives capitalised.
  it('declines an item however DM articled it', () => {
    for (const written of ['sword', 'a sword', 'the sword', 'The sword']) {
      expect(translateText(`Sir Aldric draws ${written}!`)).toBe(
        'Sir Aldric достаёт меч!',
      );
    }
  });

  it('leaves an item with no entry in English', () => {
    expect(translateText('Sir Aldric draws the volfslayer!')).toBe(
      'Sir Aldric достаёт the volfslayer!',
    );
  });

  // A player typing a bare noun must not have it rewritten. Nouns are only
  // reachable through $N|case inside a pattern, never as a text node on their own.
  it('never translates a bare noun on its own', () => {
    expect(translateText('sword')).toBe('sword');
    expect(translateText('the sword')).toBe('the sword');
  });

  // A generic "^(.+?) slashed (.+?)!$" placed first swallows both of these and
  // renders "Sir Aldric рубит themself!" / "Я рублю myself!".
  it('does not let a generic verb pattern shadow the reflexive ones', () => {
    expect(translateText('Sir Aldric slashed themself!')).toBe(
      'Sir Aldric ранит себя!',
    );
    expect(translateText('I slash myself!')).toBe('Я раню себя!');
  });

  it('leaves everything alone for an English player', () => {
    setLang('en');
    expect(isActive()).toBe(false);
    expect(translateText('SNEAK ATTACK!')).toBe('SNEAK ATTACK!');
  });

  it('survives a malformed pattern in the dictionary', () => {
    expect(translateText('Sir Aldric slashed Ivan!')).toBe(
      'Sir Aldric рубит Ивана!',
    );
  });

  it('picks up declensions that arrive after a name was already rendered', () => {
    expect(translateText('Sir Aldric slashed Bran!')).toBe(
      'Sir Aldric рубит Bran!',
    );
    loadDeclensions({ Bran: { acc: 'Брана' } });
    expect(translateText('Sir Aldric slashed Bran!')).toBe(
      'Sir Aldric рубит Брана!',
    );
  });
});
