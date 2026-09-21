import { useEffect, useState } from 'react';
import { fetchRetry } from 'tgui-core/http';

import { loadedMappings, resolveAsset } from '../assets';
import type {
  FeatureOption,
  SpeciesEntry,
  SpeciesStat,
} from './PreferencesMenu.types';

type CatalogLangSlice = {
  name: string;
  description: string;
  language: string;
  ancestry_label: string;
  ages: string;
  tags: string[];
  tag_descriptions: Record<string, string>;
  warning: string | null;
  locked_tag: string;
};

type CatalogSpecies = {
  id: string;
  stats: Record<string, SpeciesStat[]>;
  ru: CatalogLangSlice;
  en: CatalogLangSlice;
};

export type ChargenCatalog = {
  background_options: FeatureOption[];
  tgui_themes: { value: string; label: string }[];
  age_tooltips: Record<string, string>;
  species_order: string[];
  species: Record<string, CatalogSpecies>;
  option_lists: Record<string, FeatureOption[]>;
  accessory_index: Record<string, string | Record<string, string>>;
};

export type SpeciesLocks = Record<string, string>;

const ASSET_NAME = 'chargen_catalog.json';
const MAPPING_POLL_MS = 100;
const MAPPING_TIMEOUT_MS = 15000;

function delay(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function resolveWhenMapped(): Promise<string> {
  const deadline = Date.now() + MAPPING_TIMEOUT_MS;
  while (Date.now() < deadline) {
    if (loadedMappings[ASSET_NAME]) {
      break;
    }
    await delay(MAPPING_POLL_MS);
  }
  return resolveAsset(ASSET_NAME);
}

async function fetchCatalog(): Promise<ChargenCatalog> {
  const response = await fetchRetry(await resolveWhenMapped());
  if (!response.ok) {
    throw new Error(`HTTP ${response.status}`);
  }
  return await response.json();
}

export type CatalogState = {
  catalog?: ChargenCatalog;
  failed: boolean;
};

export function useChargenCatalog(): CatalogState {
  const [state, setState] = useState<CatalogState>({ failed: false });

  useEffect(() => {
    let live = true;
    fetchCatalog()
      .then((data) => {
        if (live) {
          setState({ catalog: data, failed: false });
        }
      })
      .catch(() => {
        if (live) {
          setState({ failed: true });
        }
      });
    return () => {
      live = false;
    };
  }, []);

  return state;
}

export function buildSpeciesOptions(
  catalog: ChargenCatalog | undefined,
  locks: SpeciesLocks | undefined,
  lang: string | undefined,
  gender: string | undefined,
): SpeciesEntry[] {
  if (!catalog) {
    return [];
  }
  const slice = lang === 'ru' ? 'ru' : 'en';
  const statKey = `${gender}`.toLowerCase() === 'female' ? 'female' : 'male';

  return catalog.species_order.flatMap((id) => {
    const entry = catalog.species[id];
    if (!entry) {
      return [];
    }
    const text = entry[slice];
    const lockReason = locks?.[id] ?? '';
    const available = !lockReason;

    const tags = available ? text.tags : [...text.tags, text.locked_tag];
    const tagDescriptions = { ...text.tag_descriptions };
    if (!available) {
      tagDescriptions[text.locked_tag] = lockReason;
    }

    return [
      {
        id: entry.id,
        name: text.name,
        description: text.description,
        available,
        lock_reason: lockReason,
        language: text.language,
        ancestry_label: text.ancestry_label,
        ages: text.ages,
        tags,
        tag_descriptions: tagDescriptions,
        warning: text.warning,
        stats: entry.stats[statKey] ?? [],
      },
    ];
  });
}

export function resolveAccessoryOptions(
  catalog: ChargenCatalog | undefined,
  choiceType: string | undefined,
  speciesId: string | undefined,
  gender: string | undefined,
): FeatureOption[] | undefined {
  if (!catalog || !choiceType) {
    return undefined;
  }
  const index = catalog.accessory_index[choiceType];
  if (!index) {
    return undefined;
  }
  const key =
    typeof index === 'string'
      ? index
      : index[`${speciesId}|${`${gender}`.toLowerCase()}`];
  return key ? catalog.option_lists[key] : undefined;
}
