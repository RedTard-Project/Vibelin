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
    'sword': { nom: 'меч', gen: 'меча', acc: 'меч', ins: 'мечом' },
    'chest': { nom: 'грудь', gen: 'груди', acc: 'грудь' },
    // not a noun: it lands in the same slot as a target's name, so it is
    // declined by the same mechanism instead of doubling every pattern
    'me': { nom: 'я', gen: 'меня', dat: 'мне', acc: 'меня' },
  },
  fragments: {
    'Armor stops the damage.': 'Броня поглощает урон.',
    'SNEAK ATTACK!': 'АТАКА ИСПОДТИШКА!',
    'My armor absorbs the blow!': 'Моя броня поглощает удар!',
  },
  patterns: [
    // specific before generic, exactly as strings/patterns.txt orders them
    { re: '^(.+?) slashed themself!$', ru: '$1 ранит себя!' },
    { re: '^I slash myself!$', ru: 'Я раню себя!' },
    { re: "^(.+?) slashed (.+?)!$", ru: '$1 рубит $2|acc!' },
    { re: '^I slash (.+?)!$', ru: 'Я рублю $1|acc!' },
    { re: "^(.+?) bites (.+?)'s (.+?)!$", ru: '$1 кусает $3|acc $2|gen!' },
    { re: "^dodges (.+?)'s attack!$", ru: 'уклоняется от атаки $1|gen!' },
    // the four attack shapes, longest first: each later one is a prefix of the
    // one above it, so a lazy (.+?) in the short form would eat the rest
    {
      re: '^(.+?) (?:slashes|chops at|chops) (.+?) in the (.+?) with (.+?)!$',
      ru: '$1 рубит $2|dat $3|acc $4|ins!',
    },
    {
      re: '^(.+?) (?:slashes|chops at|chops) (.+?) in the (.+?)!$',
      ru: '$1 рубит $2|dat $3|acc!',
    },
    {
      re: '^(.+?) (?:slashes|chops at|chops) (.+?) with (.+?)!$',
      ru: '$1 рубит $2|acc $3|ins!',
    },
    { re: '^You draw (.+?) from (.+?)\\.$', ru: 'Я достаю $1|acc из $2|gen.' },
    { re: '^(.+?) draws (.+?) from (.+?)!$', ru: '$1 достаёт $2|acc из $3|gen!' },
    { re: '^(.+?) draws (.+?)!$', ru: '$1 достаёт $2|acc!' },
    { re: '^It weighs around (.+?)kg\\.$', ru: 'Вес около $1 кг.' },
    { re: '^It weighs around (.+?)g\\.$', ru: 'Вес около $1 г.' },
    { re: '^BROKEN(', ru: 'never' },
  ],
};

const ALDRIC = { gen: 'сира Альдрика', acc: 'сира Альдрика' };
const IVAN = { gen: 'Ивана', dat: 'Ивану', acc: 'Ивана' };

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

  it('declines "me" so the first-person copy needs no pattern of its own', () => {
    expect(translateText('Sir Aldric slashes me in the chest!')).toBe(
      'Sir Aldric рубит мне грудь!',
    );
  });

  it('keeps the hit location out of the target capture', () => {
    expect(translateText('Sir Aldric slashes Ivan in the left arm!')).toBe(
      'Sir Aldric рубит Ивану левую руку!',
    );
  });

  it('lets the with-weapon shape win over the bare one', () => {
    expect(
      translateText('Sir Aldric slashes Ivan in the chest with the sword!'),
    ).toBe('Sir Aldric рубит Ивану грудь мечом!');
    expect(translateText('Sir Aldric slashes Ivan with the sword!')).toBe(
      'Sir Aldric рубит Ивана мечом!',
    );
  });

  it('takes the longest branch of a multi-word verb alternation', () => {
    expect(translateText('Sir Aldric chops at Ivan in the chest!')).toBe(
      'Sir Aldric рубит Ивану грудь!',
    );
  });

  it('does not let the new attack shapes shadow the possessive form', () => {
    expect(translateText("Sir Aldric bites Ivan's throat!")).toBe(
      'Sir Aldric кусает горло Ивана!',
    );
  });

  it('prefers "draws X from Y" over the bare "draws X"', () => {
    expect(translateText('Sir Aldric draws the sword from the scabbard!')).toBe(
      'Sir Aldric достаёт меч из the scabbard!',
    );
    expect(translateText('Sir Aldric draws the sword!')).toBe(
      'Sir Aldric достаёт меч!',
    );
  });

  it('matches kg before g in the examine footer', () => {
    expect(translateText('It weighs around 2.5kg.')).toBe('Вес около 2.5 кг.');
    expect(translateText('It weighs around 700g.')).toBe('Вес около 700 г.');
  });
});
