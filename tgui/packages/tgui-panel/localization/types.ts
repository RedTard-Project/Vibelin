export type Lang = 'ru' | 'en';

export type Cases = {
  nom?: string;
  gen?: string;
  dat?: string;
  acc?: string;
  ins?: string;
  pre?: string;
};

export type CaseKey = keyof Cases;

export type RawPattern = {
  re: string;
  ru: string;
};

export type Dictionary = {
  version: number;
  nouns: Record<string, Cases>;
  /**
   * Titles the server glues onto a name in the same string ("Lady Herald Ivan"),
   * which is why they need their own table: the engine may split a capture on
   * these and on nothing else.
   */
  honorifics?: Record<string, Cases>;
  fragments: Record<string, string>;
  patterns: RawPattern[];
};

export type CompiledPattern = {
  re: RegExp;
  ru: string;
};
