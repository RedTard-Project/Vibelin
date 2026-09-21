/**
 * @file Presentational pieces of PreferencesMenu, plus the constants and pure
 * helpers they share with it. Everything here is prop-only: nothing reads
 * `useBackend`, so these stay outside the main component and cannot be part of
 * a remount-per-render subtree.
 */

import { Box, Button, Icon, Section, Stack } from 'tgui-core/components';

import { usePrefsTp } from './PreferencesMenu.strings';
import type { Booleanish, FeatureOption } from './PreferencesMenu.types';

export const charSections = [
  { id: 'identity', label: 'Identity', icon: 'id-card' },
  { id: 'appearance', label: 'Appearance', icon: 'palette' },
  { id: 'gameplay', label: 'Gameplay', icon: 'gamepad' },
  { id: 'profile', label: 'Character Profile', icon: 'image' },
];

export const systemSections = [
  { id: 'erp', label: 'Intimacy', icon: 'heart' },
  { id: 'settings', label: 'Settings', icon: 'cog' },
];

export const UNDERWEAR_KEY = '__underwear__';
export const FACE_KEY = '__face__';
export const TAUR_KEY = '__taur__';
export const BACKDROP_KEY = '__backdrop__';

export const FACE_PATTERNS = ['face_detail', 'eyes', 'facial_hair'];
export const isFaceFeature = (key: string) =>
  FACE_PATTERNS.some((pattern) => key.includes(pattern));

export const asBool = (value: Booleanish | undefined) =>
  value === true || value === 1;

export const display = (value: unknown, fallback = 'None') => {
  const text = String(value ?? '').trim();
  return text || fallback;
};

export const swatchColor = (value: string) => {
  const text = String(value || '').trim();
  if (!text) {
    return '#888888';
  }
  return text.startsWith('#') ? text : `#${text}`;
};

export const clampPreviewScale = (value: unknown) => {
  const scale = Math.round(Number(value));
  if (!Number.isFinite(scale)) {
    return 1;
  }
  return Math.max(1, Math.min(3, scale));
};

export const clampMenuScale = (value: unknown) => {
  const scale = Number(value);
  if (!Number.isFinite(scale)) {
    return 1;
  }
  return Math.max(0.8, Math.min(1.25, Math.round(scale * 20) / 20));
};

export const formatRoundCountdown = (seconds: number) => {
  if (!Number.isFinite(seconds) || seconds < 0) {
    return 'DELAYED';
  }
  const minutes = Math.floor(seconds / 60);
  const remainder = seconds % 60;
  if (minutes <= 0) {
    return `${remainder}s`;
  }
  return `${minutes}:${String(remainder).padStart(2, '0')}`;
};

export type PanelProps = {
  title: string;
  icon?: string;
  buttons?: React.ReactNode;
  children?: React.ReactNode;
};

export const Panel = (props: PanelProps) => {
  const { title, icon, buttons, children } = props;
  const tp = usePrefsTp();
  return (
    <Section
      mb={1}
      title={
        <Stack align="center">
          {icon ? (
            <Stack.Item>
              <Icon name={icon} />
            </Stack.Item>
          ) : null}
          <Stack.Item>{tp(title)}</Stack.Item>
        </Stack>
      }
      buttons={buttons}
    >
      {children}
    </Section>
  );
};

export type PrefRowProps = {
  icon: string;
  label: string;
  value?: unknown;
  onClick?: () => void;
  disabled?: boolean;
  selected?: boolean;
  swatch?: string;
  tooltip?: string;
};

/**
 * The cases the chat panel can decline a character's name into. Leaving one
 * blank is fine: chat falls back to the nominative for that case.
 */
export const DECLENSION_CASES = [
  {
    key: 'declension_genitive',
    case: 'gen',
    label: 'Родительный',
    tooltip: 'Кого? Чего? — Ивана Петрова',
  },
  {
    key: 'declension_dative',
    case: 'dat',
    label: 'Дательный',
    tooltip: 'Кому? Чему? — Ивану Петрову',
  },
  {
    key: 'declension_accusative',
    case: 'acc',
    label: 'Винительный',
    tooltip: 'Кого? Что? — Ивана Петрова',
  },
  {
    key: 'declension_instrumental',
    case: 'ins',
    label: 'Творительный',
    tooltip: 'Кем? Чем? — Иваном Петровым',
  },
  {
    key: 'declension_prepositional',
    case: 'pre',
    label: 'Предложный',
    tooltip: 'О ком? О чём? — Иване Петрове',
  },
] as const;

export const PrefRow = (props: PrefRowProps) => {
  const { icon, label, value, onClick, disabled, selected, swatch, tooltip } =
    props;
  const tp = usePrefsTp();
  return (
    <Button
      fluid
      mb={0.5}
      disabled={disabled}
      selected={selected}
      tooltip={tp(tooltip || label)}
      onClick={onClick}
    >
      <Stack align="center">
        <Stack.Item>
          <Icon name={icon} />
        </Stack.Item>
        <Stack.Item grow>
          <Box textAlign="left">{tp(label)}</Box>
        </Stack.Item>
        {swatch ? (
          <Stack.Item>
            <Box
              width="12px"
              height="12px"
              style={{ border: '1px solid rgba(0,0,0,0.6)' }}
              backgroundColor={swatchColor(swatch)}
            />
          </Stack.Item>
        ) : null}
        <Stack.Item>
          <Box bold>{display(tp(value))}</Box>
        </Stack.Item>
      </Stack>
    </Button>
  );
};

export const InfoRow = (props: {
  icon: string;
  label: string;
  value?: unknown;
  valueColor?: string;
}) => {
  const { icon, label, value, valueColor } = props;
  const tp = usePrefsTp();
  return (
    <Box mb={0.5} p={0.5}>
      <Stack align="center">
        <Stack.Item>
          <Icon name={icon} />
        </Stack.Item>
        <Stack.Item grow>
          <Box textAlign="left">{tp(label)}</Box>
        </Stack.Item>
        <Stack.Item>
          <Box bold color={valueColor}>
            {display(tp(value))}
          </Box>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

export const ActionButton = (props: {
  icon: string;
  label: string;
  onClick?: () => void;
  color?: string;
  disabled?: boolean;
  selected?: boolean;
}) => {
  const { icon, label, onClick, color, disabled, selected } = props;
  const tp = usePrefsTp();
  return (
    <Button
      fluid
      mb={0.5}
      textAlign="center"
      icon={icon}
      color={color || undefined}
      disabled={disabled}
      selected={selected}
      tooltip={tp(label)}
      onClick={onClick}
    >
      {tp(label)}
    </Button>
  );
};

/**
 * Mirrors sanitize_css_class_name() (code/modules/asset_cache/asset_list.dm):
 * the spritesheet class for an accessory is its type path with everything
 * non-alphanumeric stripped. The server used to ship the whole path->class map
 * in ui_static_data, which was ~80 KB of values that are a pure function of
 * their own keys.
 */
export function spriteClassFor(value: string): string {
  return value.replace(/[^a-zA-Z0-9]/g, '');
}

export const OptionGrid = (props: {
  options: FeatureOption[];
  selected?: string;
  onSelect: (value: string) => void;
  onHover?: (value: string | null) => void;
  /** Accessory grids render a spritesheet thumbnail; choice grids do not. */
  spriteThumbs?: boolean;
  labelSize?: string;
}) => {
  const { options, selected, onSelect, onHover, spriteThumbs, labelSize } =
    props;
  const thumbOf = (option: FeatureOption) =>
    spriteThumbs ? spriteClassFor(option.value) : undefined;
  const hasThumbs = spriteThumbs && options.length > 0;
  const optionLabelSize = labelSize || (hasThumbs ? '10px' : '11px');
  return (
    <Box style={{ display: 'flex', flexWrap: 'wrap' }}>
      {options.map((option) => {
        const thumb = thumbOf(option);
        return (
          <Button
            key={option.value}
            mr={0.5}
            mb={0.5}
            tooltip={
              option.coverage
                ? `${option.name} - covers ${option.coverage}`
                : option.name
            }
            selected={String(selected) === String(option.value)}
            onClick={() => onSelect(option.value)}
            onMouseOver={() => onHover?.(option.value)}
            onMouseLeave={() => onHover?.(null)}
            style={
              hasThumbs
                ? { width: '66px', height: '80px', padding: '2px' }
                : undefined
            }
          >
            {hasThumbs ? (
              <Box
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  height: '50px',
                }}
              >
                {thumb ? (
                  <Box
                    className={`character_setup_chargen48x48 ${thumb}`}
                    style={{
                      width: '48px',
                      height: '48px',
                      imageRendering: 'pixelated',
                    }}
                  />
                ) : (
                  <Icon name="ban" color="label" />
                )}
              </Box>
            ) : null}
            <Box
              style={{
                fontSize: optionLabelSize,
                lineHeight: '1.15',
                overflow: 'hidden',
                whiteSpace: 'nowrap',
                textOverflow: 'ellipsis',
                textAlign: 'center',
              }}
            >
              {option.name}
            </Box>
          </Button>
        );
      })}
    </Box>
  );
};

export const FieldBlock = (props: {
  label: string;
  children: React.ReactNode;
  labelSize?: string;
}) => {
  const tp = usePrefsTp();
  return (
    <Box mb={1}>
      <Box
        color="label"
        mb={0.5}
        style={{ fontSize: props.labelSize || '12px', lineHeight: '1.2' }}
      >
        {tp(props.label)}
      </Box>
      {props.children}
    </Box>
  );
};
