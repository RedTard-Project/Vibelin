/**
 * @file Payload and option shapes for PreferencesMenu.
 */

import type { Lang } from '../i18n';

export type Booleanish = boolean | number;

export type LoadoutSlot = {
  slot: number;
  name: string;
};

export type SpeciesStat = {
  name: string;
  label: string;
  value: number;
};

export type SpeciesEntry = {
  id: string;
  name: string;
  description: string;
  available: Booleanish;
  lock_reason: string;
  language: string;
  ancestry_label: string;
  ages: string;
  tags: string[];
  tag_descriptions?: Record<string, string>;
  stats: SpeciesStat[];
};

export type PatronEntry = {
  id: string;
  name: string;
  domain: string;
  description: string;
  flaws: string;
  worshippers: string;
  sins: string;
  boons: string;
  available: Booleanish;
  selected: Booleanish;
};

export type FaithEntry = {
  id: string;
  name: string;
  description: string;
  available: Booleanish;
  selected: Booleanish;
  patrons: PatronEntry[];
};

export type AncestryOption = {
  name: string;
  value: string;
  color: string;
  selected: Booleanish;
};

export type OocMessage = {
  sender: string;
  message: string;
  time: string;
};

export type FeatureOption = {
  name: string;
  value: string;
  coverage?: string;
};

export type FeatureColor = {
  name: string;
  value: string;
  index: string;
};

export type FeatureExtra = {
  task: string;
  label: string;
  kind: 'color' | 'text';
  value: string;
};

export type FeatureEntry = {
  key: string;
  name: string;
  enabled: Booleanish;
  can_disable: Booleanish;
  choice_name: string;
  choice_value?: string;
  accessory_name?: string;
  accessory_value?: string;
  colors?: FeatureColor[];
  extras?: FeatureExtra[];
  erp?: Booleanish;
  section?: string;
};

export type PrefsData = {
  lang?: Lang;
  real_name: string;
  declensions?: Record<string, string>;
  initial_tab: string;
  tgui_theme: string;
  tgui_themes: { value: string; label: string }[];
  tgui_font_size: number | null;
  tgui_line_height: number | null;
  tgui_text_bounds: {
    font_min: number;
    font_max: number;
    font_default: number;
    line_min: number;
    line_max: number;
    line_step: number;
    line_default: number;
  };
  open_sequence: number;
  preferences_fullscreen: Booleanish;
  preferences_scale: number;
  preview_scale: number;
  species_id: string;
  species_name: string;
  species_options: SpeciesEntry[];
  is_taur: Booleanish;
  taur_body: string;
  taur_color: string;
  taur_markings: string;
  taur_tertiary: string;
  gender: string;
  gender_short: string;
  default_slot: number;
  patron_name: string;
  faith_name: string;
  selected_patron_id: string;
  selected_faith_id: string;
  faith_options: FaithEntry[];
  high_job: string;
  age: string;
  age_index: number;
  age_min: number;
  age_max: number;
  age_options: string[];
  age_tooltips: Record<string, string>;
  pronouns: string;
  domhand: string;
  ancestry_label: string;
  ancestry_value: string;
  ancestry_options: AncestryOption[];
  erp_enabled: Booleanish;
  headshot: string | null;
  features: FeatureEntry[];
  preview_underwear: Booleanish;
  preview_clothes: Booleanish;
  preview_dir: number;
  background: string;
  background_options: FeatureOption[];
  // Option catalogs ride in ui_static_data: they change only with species,
  // gender or the ERP toggle, while the selections in `features` change on
  // every pick. Keyed by customizer type and by customizer-choice type
  // respectively — the accessory list belongs to the chosen variant, not to
  // the customizer.
  feature_choice_options?: Record<string, FeatureOption[]>;
  feature_accessory_options?: Record<string, FeatureOption[]>;
  preview_map: string | null;
  preview_map_front: string | null;
  preview_map_side: string | null;
  preview_bbox_w: number;
  preview_bbox_h: number;
  culture_name: string;
  voice_type: string;
  voice_color: string;
  selected_accent: string;
  family: string;
  gender_pref: string;
  spouse: string;
  loadouts: LoadoutSlot[];
  triumphs: number;
  special_role: string;
  round_start_status: string;
  round_start_seconds: number;
  round_ready_players: number;
  round_total_players: number;
  round_player_ready: Booleanish;
  round_action_label: string;
  round_action_icon: string;
  round_action_color: string | null;
  round_action_disabled: Booleanish;
  round_action_tooltip: string;
  ooc_messages: OocMessage[];
  player_quality: string;
  player_quality_color: string | null;
  game_prefs: {
    hotkeys: Booleanish;
    buttons_locked: Booleanish;
    see_chat_non_mob: Booleanish;
    tgui_fancy: Booleanish;
    tgui_lock: Booleanish;
    windowflashing: Booleanish;
    lobby_music: Booleanish;
    hear_midis: Booleanish;
    ambientocclusion: Booleanish;
    auto_fit_viewport: Booleanish;
    widescreenpref: Booleanish;
    allow_midround_antag: Booleanish;
    pixel_size: string;
    scaling_method: string;
    language: string;
  };
};
