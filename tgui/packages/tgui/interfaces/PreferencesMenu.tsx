import { Fragment, useEffect, useRef, useState } from 'react';
import {
  Box,
  Button,
  Dropdown,
  Icon,
  Input,
  Section,
  Stack,
  Tabs,
  TextArea,
  Tooltip,
} from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';
import { ByondMapView } from './_common/ByondMapView';
import {
  buildSpeciesOptions,
  resolveAccessoryOptions,
  useChargenCatalog,
} from './PreferencesMenu.catalog';
import {
  ActionButton,
  asBool,
  BACKDROP_KEY,
  charSections,
  clampMenuScale,
  clampPreviewScale,
  DECLENSION_CASES,
  display,
  FACE_KEY,
  FieldBlock,
  formatRoundCountdown,
  InfoRow,
  isFaceFeature,
  OptionGrid,
  Panel,
  PrefRow,
  swatchColor,
  systemSections,
  TAUR_KEY,
  UNDERWEAR_KEY,
} from './PreferencesMenu.components';
import { usePrefsTp } from './PreferencesMenu.strings';
import type { FeatureEntry, PrefsData } from './PreferencesMenu.types';

export const PreferencesMenu = () => {
  const { act, data } = useBackend<PrefsData>();
  const tp = usePrefsTp();

  const mapTab = (tab: string) => (tab === 'game' ? 'settings' : 'identity');
  const [menuScale, setMenuScaleState] = useState(
    clampMenuScale(data.preferences_scale),
  );
  const [previewScale, setPreviewScaleState] = useState(
    clampPreviewScale(data.preview_scale),
  );
  const isFullscreen = asBool(data.preferences_fullscreen);
  const windowWidth = isFullscreen ? 7680 : 1180;
  const windowHeight = isFullscreen ? 4320 : 760;
  const scaledContentStyle =
    menuScale === 1
      ? undefined
      : {
          transform: `scale(${menuScale})`,
          transformOrigin: 'top left',
          width: `${100 / menuScale}%`,
          height: `${100 / menuScale}%`,
        };

  const [activeSection, setActiveSection] = useState(mapTab(data.initial_tab));
  const [activeFeature, setActiveFeature] = useState<string>(UNDERWEAR_KEY);
  const [speciesFilter, setSpeciesFilter] = useState<
    'all' | 'available' | 'locked'
  >('all');
  const [selectionMode, setSelectionMode] = useState<
    'species' | 'faith' | 'ancestry'
  >('species');
  const [speciesSearch, setSpeciesSearch] = useState('');
  const [previewSpeciesId, setPreviewSpeciesId] = useState<string | null>(null);
  const [previewFaithId, setPreviewFaithId] = useState<string | null>(null);
  const [oocMessage, setOocMessage] = useState('');
  const [oocExpanded, setOocExpanded] = useState(true);
  const hoverTimer = useRef<ReturnType<typeof setTimeout> | null>(null);
  const dollBoxRef = useRef<HTMLDivElement>(null);
  const frontBoxRef = useRef<HTMLDivElement>(null);
  const sideBoxRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    setActiveSection(mapTab(data.initial_tab));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [data.open_sequence]);

  useEffect(() => {
    setPreviewSpeciesId(data.species_id || null);
  }, [data.open_sequence, data.species_id]);

  useEffect(() => {
    setPreviewFaithId(data.selected_faith_id || null);
  }, [data.open_sequence, data.selected_faith_id]);

  const [previewBoxPx, setPreviewBoxPx] = useState({
    main: 0,
    mainH: 0,
    mini: 0,
  });

  useEffect(() => {
    const measure = () => {
      const dpr = window.devicePixelRatio || 1;
      const mainRect = dollBoxRef.current?.getBoundingClientRect();
      const main = Math.floor((mainRect?.width ?? 0) * dpr);
      const mainH = Math.floor((mainRect?.height ?? 0) * dpr);
      const mini = Math.floor(
        (frontBoxRef.current?.getBoundingClientRect().width ?? 0) * dpr,
      );
      setPreviewBoxPx((prev) =>
        prev.main === main && prev.mainH === mainH && prev.mini === mini
          ? prev
          : { main, mainH, mini },
      );
    };
    let nudgeTimer: ReturnType<typeof setTimeout> | null = null;
    const nudge = () => {
      if (nudgeTimer) {
        clearTimeout(nudgeTimer);
      }
      nudgeTimer = setTimeout(() => {
        measure();
        window.dispatchEvent(new Event('resize'));
      }, 50);
    };
    measure();
    const timers = [250, 700, 1600].map((delay) => setTimeout(measure, delay));
    window.addEventListener('resize', measure);
    let observer: ResizeObserver | undefined;
    if (typeof ResizeObserver !== 'undefined') {
      observer = new ResizeObserver(nudge);
      for (const el of [
        dollBoxRef.current,
        frontBoxRef.current,
        sideBoxRef.current,
      ]) {
        if (el) {
          observer.observe(el);
        }
      }
    }
    return () => {
      timers.forEach(clearTimeout);
      if (nudgeTimer) {
        clearTimeout(nudgeTimer);
      }
      window.removeEventListener('resize', measure);
      observer?.disconnect();
    };
  }, [
    data.preview_map,
    menuScale,
    previewScale,
    data.preferences_fullscreen,
    data.tgui_theme,
  ]);

  const previewBboxW = Math.max(16, Number(data.preview_bbox_w) || 0);
  const previewBboxH = Math.max(16, Number(data.preview_bbox_h) || 0);
  const previewZoomFor = (boxW: number, boxH: number) =>
    boxW && boxH
      ? Math.max(
          1,
          Math.floor(
            Math.min(
              (boxW * 0.95) / previewBboxW,
              (boxH * 0.85) / previewBboxH,
            ),
          ),
        )
      : 0;
  const previewZoom = previewZoomFor(previewBoxPx.main, previewBoxPx.mainH);
  const previewMiniZoom = previewZoomFor(previewBoxPx.mini, previewBoxPx.mini);

  useEffect(() => {
    const report = () => {
      const m = dollBoxRef.current?.getBoundingClientRect();
      const f = frontBoxRef.current?.getBoundingClientRect();
      const s = sideBoxRef.current?.getBoundingClientRect();
      act('pref', {
        preference: 'character_setup_report_geometry',
        main_w: Math.round(m?.width ?? 0),
        main_h: Math.round(m?.height ?? 0),
        front_w: Math.round(f?.width ?? 0),
        front_h: Math.round(f?.height ?? 0),
        side_w: Math.round(s?.width ?? 0),
        side_h: Math.round(s?.height ?? 0),
        win_w: Math.round(window.innerWidth),
        win_h: Math.round(window.innerHeight),
        dpr: window.devicePixelRatio,
        menu_scale: menuScale,
        zoom_main: previewZoom,
        zoom_mini: previewMiniZoom,
        bbox: `${data.preview_bbox_w}x${data.preview_bbox_h}`,
      });
    };
    const t = setTimeout(report, 250);
    return () => clearTimeout(t);
  }, [
    data.preview_map,
    menuScale,
    previewScale,
    data.preferences_fullscreen,
    previewZoom,
    previewMiniZoom,
    data.tgui_theme,
  ]);

  const [localRoundSeconds, setLocalRoundSeconds] = useState<number>(-1);

  useEffect(() => {
    setLocalRoundSeconds(Number(data.round_start_seconds ?? -1));
  }, [data.round_start_seconds]);

  useEffect(() => {
    if (localRoundSeconds <= 0) {
      return;
    }
    const timer = setTimeout(
      () => setLocalRoundSeconds(localRoundSeconds - 1),
      1000,
    );
    return () => clearTimeout(timer);
  }, [localRoundSeconds]);

  const { catalog, failed: catalogFailed } = useChargenCatalog();
  const speciesOptions = buildSpeciesOptions(
    catalog,
    data.species_locks,
    data.lang,
    data.gender_key,
  );

  const ageOptions = data.age_options ?? [];
  const erpEnabled = asBool(data.erp_enabled);
  const loadouts = data.loadouts ?? [];
  const backdropColor =
    data.background === 'white'
      ? '#d8d8d8'
      : data.background === 'dark'
        ? '#0a0a0a'
        : undefined;

  const doPref = (
    preference: string,
    task?: string,
    extra?: Record<string, unknown>,
  ) => {
    act('pref', {
      preference,
      ...(task ? { task } : {}),
      ...(extra || {}),
    });
  };

  const sendOocMessage = () => {
    const message = oocMessage.trim();
    if (!message) {
      return;
    }
    doPref('character_setup_send_ooc', undefined, { message });
    setOocMessage('');
  };

  const setPreviewScale = (scale: number) => {
    const clamped = clampPreviewScale(scale);
    setPreviewScaleState(clamped); // resize now, let the savefile catch up
    doPref('character_setup_preview_scale', undefined, {
      scale: clamped,
    });
  };

  const setMenuScale = (scale: number) => {
    const clamped = clampMenuScale(scale);
    setMenuScaleState(clamped); // apply instantly so the screen doesn't jerk
    doPref('character_setup_preferences_scale', undefined, {
      scale: clamped,
    });
  };

  const customizerAct = (
    key: string,
    task: string,
    extra?: Record<string, unknown>,
  ) => {
    doPref('character_setup_customizer', undefined, {
      customizer: key,
      customizer_task: task,
      ...(extra || {}),
    });
  };

  const requestHover = (
    value: string | null,
    color?: string,
    customizer?: string,
  ) => {
    if (hoverTimer.current) {
      clearTimeout(hoverTimer.current);
      hoverTimer.current = null;
    }
    hoverTimer.current = setTimeout(
      () => {
        doPref('character_setup_hover', undefined, {
          acc: value || '',
          color: value ? color || '' : '',
          customizer: value ? customizer || '' : '',
        });
      },
      value ? 180 : 260,
    );
  };

  const headerMeta = [
    data.species_name,
    data.gender,
    `Slot ${display(data.default_slot, '1')}`,
  ]
    .filter(Boolean)
    .join('  /  ');
  const roundStatus = display(data.round_start_status, 'Unknown');
  const roundSeconds = localRoundSeconds;
  const roundCountdown =
    roundStatus === 'Round Started' || roundStatus === 'Setting Up'
      ? roundStatus
      : formatRoundCountdown(roundSeconds);
  const roundStatusColor =
    roundStatus === 'Delayed'
      ? 'bad'
      : roundStatus === 'Starts In'
        ? 'good'
        : 'average';

  // ---- Detail panels ----

  const renderSelectionModeButtons = () => (
    <Box>
      <Button
        compact
        icon="users"
        selected={selectionMode === 'species'}
        onClick={() => setSelectionMode('species')}
      >
        Species
      </Button>
      <Button
        compact
        icon="asterisk"
        selected={selectionMode === 'faith'}
        onClick={() => setSelectionMode('faith')}
      >
        Faith
      </Button>
      <Button
        compact
        icon="leaf"
        selected={selectionMode === 'ancestry'}
        onClick={() => setSelectionMode('ancestry')}
      >
        {display(data.ancestry_label, 'Ancestry')}
      </Button>
    </Box>
  );

  const renderSpeciesPicker = () => {
    const currentSpecies =
      speciesOptions.find((species) => species.id === data.species_id) ||
      speciesOptions.find((species) => species.name === data.species_name);
    const inspectedSpecies =
      speciesOptions.find((species) => species.id === previewSpeciesId) ||
      currentSpecies ||
      speciesOptions[0];
    const search = speciesSearch.trim().toLowerCase();
    const filteredSpecies = speciesOptions
      .filter((species) => {
        const available = asBool(species.available);
        if (speciesFilter === 'available' && !available) {
          return false;
        }
        if (speciesFilter === 'locked' && available) {
          return false;
        }
        if (!search) {
          return true;
        }
        return (
          species.name.toLowerCase().includes(search) ||
          species.id.toLowerCase().includes(search) ||
          (species.tags || []).some((tag) => tag.toLowerCase().includes(search))
        );
      })
      .sort((left, right) => {
        const availableDelta =
          Number(asBool(right.available)) - Number(asBool(left.available));
        return availableDelta || left.name.localeCompare(right.name);
      });

    const canApply = !!(
      inspectedSpecies &&
      asBool(inspectedSpecies.available) &&
      inspectedSpecies.id !== data.species_id
    );

    const SpeciesFilterButton = (props: {
      id: 'all' | 'available' | 'locked';
      label: string;
      icon: string;
    }) => (
      <Button
        icon={props.icon}
        selected={speciesFilter === props.id}
        onClick={() => setSpeciesFilter(props.id)}
      >
        {tp(props.label)}
      </Button>
    );

    return (
      <Panel title="Choose Species" icon="users">
        <Stack>
          <Stack.Item basis="265px">
            <Input
              fluid
              placeholder={tp('Search species...')}
              value={speciesSearch}
              onChange={(value: string) => setSpeciesSearch(value)}
            />
            <Box mt={0.5} mb={0.75}>
              <SpeciesFilterButton id="all" label="All" icon="list" />
              <SpeciesFilterButton
                id="available"
                label="Open"
                icon="check-circle"
              />
              <SpeciesFilterButton id="locked" label="Locked" icon="lock" />
            </Box>
            <Box
              style={{
                maxHeight: '360px',
                overflowY: 'auto',
                paddingRight: '3px',
              }}
            >
              {filteredSpecies.length ? (
                filteredSpecies.map((species) => {
                  const selected = species.id === inspectedSpecies?.id;
                  const current = species.id === data.species_id;
                  const available = asBool(species.available);
                  return (
                    <Button
                      key={species.id}
                      fluid
                      mb={0.5}
                      selected={selected}
                      tooltip={species.name}
                      onClick={() => setPreviewSpeciesId(species.id)}
                      style={{
                        minHeight: '52px',
                        padding: '5px 6px',
                      }}
                    >
                      <Stack align="center">
                        <Stack.Item>
                          <Icon
                            name={
                              current
                                ? 'check-circle'
                                : available
                                  ? 'user'
                                  : 'lock'
                            }
                            color={
                              current
                                ? 'good'
                                : available
                                  ? undefined
                                  : 'average'
                            }
                          />
                        </Stack.Item>
                        <Stack.Item grow>
                          <Box textAlign="left" bold>
                            {species.name}
                          </Box>
                          <Box
                            textAlign="left"
                            color="label"
                            style={{
                              fontSize: '10px',
                              lineHeight: '12px',
                              overflow: 'hidden',
                              whiteSpace: 'normal',
                              maxHeight: '24px',
                            }}
                          >
                            {available
                              ? (species.tags || []).slice(0, 2).join(' / ') ||
                                species.language
                              : species.lock_reason || 'Unavailable'}
                          </Box>
                        </Stack.Item>
                      </Stack>
                    </Button>
                  );
                })
              ) : (
                <Box color="label" py={2} textAlign="center">
                  {catalogFailed
                    ? tp('Species catalog failed to load.')
                    : catalog
                      ? tp('No species match.')
                      : tp('Loading species…')}
                </Box>
              )}
            </Box>
          </Stack.Item>

          <Stack.Item grow basis={0}>
            {inspectedSpecies ? (
              <Section
                fill
                title={
                  <Stack align="center">
                    <Stack.Item>{inspectedSpecies.name}</Stack.Item>
                    {inspectedSpecies.id === data.species_id ? (
                      <Stack.Item>
                        <Box color="good">{tp('Current')}</Box>
                      </Stack.Item>
                    ) : null}
                  </Stack>
                }
                buttons={
                  !asBool(inspectedSpecies.available) ? (
                    <Button icon="lock" disabled>
                      {display(inspectedSpecies.lock_reason, 'Locked')}
                    </Button>
                  ) : null
                }
              >
                <Stack align="center" mb={1}>
                  <Stack.Item grow>
                    <Box color="label">
                      {inspectedSpecies.id === data.species_id
                        ? tp('Selected species')
                        : asBool(inspectedSpecies.available)
                          ? tp('Ready to apply')
                          : tp(display(inspectedSpecies.lock_reason, 'Locked'))}
                    </Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon={
                        inspectedSpecies.id === data.species_id || canApply
                          ? 'check'
                          : 'lock'
                      }
                      color={canApply ? 'green' : undefined}
                      disabled={!canApply}
                      tooltip={tp(
                        canApply
                          ? 'Apply species'
                          : inspectedSpecies.id === data.species_id
                            ? 'Current species'
                            : inspectedSpecies.lock_reason || 'Unavailable',
                      )}
                      onClick={() =>
                        doPref('character_setup_select_species', undefined, {
                          species_id: inspectedSpecies.id,
                        })
                      }
                    >
                      {tp(
                        inspectedSpecies.id === data.species_id
                          ? 'Current Species'
                          : asBool(inspectedSpecies.available)
                            ? 'Apply Species'
                            : 'Locked',
                      )}
                    </Button>
                  </Stack.Item>
                </Stack>
                <Box
                  mb={1}
                  color={
                    asBool(inspectedSpecies.available) ? undefined : 'label'
                  }
                  style={{
                    minHeight: '118px',
                    maxHeight: '132px',
                    overflowY: 'auto',
                    whiteSpace: 'pre-line',
                  }}
                >
                  {display(inspectedSpecies.description, 'No description.')}
                </Box>

                {inspectedSpecies.warning ? (
                  <Box
                    mb={1}
                    bold
                    color="bad"
                    style={{
                      whiteSpace: 'normal',
                      overflowWrap: 'anywhere',
                      lineHeight: '15px',
                    }}
                  >
                    {inspectedSpecies.warning}
                  </Box>
                ) : null}

                <Stack mb={1}>
                  <Stack.Item grow>
                    <InfoRow
                      icon="language"
                      label="Language"
                      value={inspectedSpecies.language}
                    />
                  </Stack.Item>
                  <Stack.Item grow>
                    <InfoRow
                      icon="leaf"
                      label="Ancestry"
                      value={inspectedSpecies.ancestry_label}
                    />
                  </Stack.Item>
                </Stack>
                <InfoRow
                  icon="hourglass-half"
                  label="Ages"
                  value={inspectedSpecies.ages}
                />

                {inspectedSpecies.stats?.length ? (
                  <FieldBlock label="Stat modifiers">
                    <Box
                      style={{ display: 'flex', flexWrap: 'wrap', gap: '4px' }}
                    >
                      {inspectedSpecies.stats.map((stat) => (
                        <Button
                          key={stat.label}
                          compact
                          tooltip={stat.name}
                          color={stat.value > 0 ? 'green' : 'bad'}
                        >
                          {stat.label} {stat.value > 0 ? '+' : ''}
                          {stat.value}
                        </Button>
                      ))}
                    </Box>
                  </FieldBlock>
                ) : (
                  <FieldBlock label="Stat modifiers">
                    <Box color="label">No stat modifiers.</Box>
                  </FieldBlock>
                )}

                <FieldBlock label="Tags">
                  <Box
                    style={{ display: 'flex', flexWrap: 'wrap', gap: '4px' }}
                  >
                    {(inspectedSpecies.tags || []).map((tag) => (
                      <Button
                        key={tag}
                        compact
                        color="transparent"
                        tooltip={
                          inspectedSpecies.tag_descriptions?.[tag] || tag
                        }
                        style={{
                          maxWidth: '100%',
                          whiteSpace: 'normal',
                          lineHeight: '14px',
                        }}
                      >
                        {tag}
                      </Button>
                    ))}
                  </Box>
                </FieldBlock>

                {!asBool(inspectedSpecies.available) ? (
                  <Box color="average">
                    <Icon name="lock" /> {display(inspectedSpecies.lock_reason)}
                  </Box>
                ) : null}
              </Section>
            ) : (
              <Section fill>
                <Box color="label">No species available.</Box>
              </Section>
            )}
          </Stack.Item>
        </Stack>
      </Panel>
    );
  };

  const renderFaithPicker = () => {
    const faithOptions = data.faith_options ?? [];
    const currentFaith = faithOptions.find((faith) => asBool(faith.selected));
    const inspectedFaith =
      faithOptions.find((faith) => faith.id === previewFaithId) ||
      currentFaith ||
      faithOptions[0];
    const selectedPatron =
      inspectedFaith?.patrons?.find((patron) => asBool(patron.selected)) ||
      inspectedFaith?.patrons?.[0];

    return (
      <Panel title="Choose Faith" icon="asterisk">
        <Stack wrap>
          <Stack.Item basis="220px" style={{ minWidth: 0 }}>
            <Box
              p={0.5}
              style={{
                maxHeight: '420px',
                overflowY: 'auto',
                border: '1px solid rgba(255,255,255,0.18)',
                backgroundColor: 'rgba(0,0,0,0.22)',
              }}
            >
              {faithOptions.length ? (
                faithOptions.map((faith) => (
                  <Button
                    key={faith.id}
                    fluid
                    mb={0.5}
                    selected={faith.id === inspectedFaith?.id}
                    disabled={!asBool(faith.available)}
                    tooltip={faith.name}
                    onClick={() => setPreviewFaithId(faith.id)}
                    style={{ minHeight: '46px', padding: '5px 6px' }}
                  >
                    <Stack align="center">
                      <Stack.Item>
                        <Icon
                          name={
                            asBool(faith.selected) ? 'check-circle' : 'asterisk'
                          }
                          color={asBool(faith.selected) ? 'good' : undefined}
                        />
                      </Stack.Item>
                      <Stack.Item grow>
                        <Box textAlign="left" bold>
                          {faith.name}
                        </Box>
                        <Box
                          textAlign="left"
                          color="label"
                          style={{ fontSize: '10px', lineHeight: '12px' }}
                        >
                          {(faith.patrons || []).length} patrons
                        </Box>
                      </Stack.Item>
                    </Stack>
                  </Button>
                ))
              ) : (
                <Box color="label" py={2} textAlign="center">
                  No faiths available.
                </Box>
              )}
            </Box>
          </Stack.Item>

          <Stack.Item grow basis="260px" style={{ minWidth: 0 }}>
            {inspectedFaith ? (
              <Section
                fill
                title={
                  <Stack align="center">
                    <Stack.Item>{inspectedFaith.name}</Stack.Item>
                    {asBool(inspectedFaith.selected) ? (
                      <Stack.Item>
                        <Box color="good">{tp('Current')}</Box>
                      </Stack.Item>
                    ) : null}
                  </Stack>
                }
                buttons={
                  asBool(inspectedFaith.available) &&
                  !asBool(inspectedFaith.selected) ? (
                    <Button
                      icon="check"
                      color="green"
                      tooltip={tp("Choose this faith's godhead")}
                      onClick={() =>
                        doPref('character_setup_select_faith', undefined, {
                          faith_id: inspectedFaith.id,
                        })
                      }
                    >
                      Use Faith
                    </Button>
                  ) : null
                }
              >
                <Box
                  mb={1}
                  style={{
                    maxHeight: '92px',
                    overflowY: 'auto',
                    whiteSpace: 'pre-line',
                  }}
                >
                  {display(inspectedFaith.description, 'No description.')}
                </Box>

                <FieldBlock label="Patrons">
                  <Box
                    p={0.5}
                    style={{
                      maxHeight: '300px',
                      overflowY: 'auto',
                      overflowX: 'hidden',
                      border: '1px solid rgba(255,255,255,0.18)',
                      backgroundColor: 'rgba(0,0,0,0.22)',
                    }}
                  >
                    {(inspectedFaith.patrons || []).map((patron) => (
                      <Button
                        key={patron.id}
                        fluid
                        mb={0.5}
                        selected={asBool(patron.selected)}
                        disabled={!asBool(patron.available)}
                        tooltip={patron.domain || patron.name}
                        onClick={() =>
                          doPref('character_setup_select_patron', undefined, {
                            patron_id: patron.id,
                          })
                        }
                        style={{ padding: '6px', minHeight: '58px' }}
                      >
                        <Stack align="center">
                          <Stack.Item>
                            <Icon
                              name={
                                asBool(patron.selected)
                                  ? 'check-circle'
                                  : 'star'
                              }
                              color={
                                asBool(patron.selected) ? 'good' : undefined
                              }
                            />
                          </Stack.Item>
                          <Stack.Item grow style={{ minWidth: 0 }}>
                            <Box
                              textAlign="left"
                              bold
                              style={{
                                whiteSpace: 'normal',
                                overflowWrap: 'anywhere',
                              }}
                            >
                              {patron.name}
                            </Box>
                            <Box
                              textAlign="left"
                              color="label"
                              style={{
                                whiteSpace: 'normal',
                                overflowWrap: 'anywhere',
                                lineHeight: '13px',
                              }}
                            >
                              {display(patron.domain)}
                            </Box>
                            <Box
                              textAlign="left"
                              style={{
                                fontSize: '11px',
                                lineHeight: '13px',
                                whiteSpace: 'normal',
                                overflowWrap: 'anywhere',
                                display: '-webkit-box',
                                WebkitLineClamp: 2,
                                WebkitBoxOrient: 'vertical',
                                overflow: 'hidden',
                              }}
                            >
                              {display(patron.description, 'No description.')}
                            </Box>
                          </Stack.Item>
                        </Stack>
                      </Button>
                    ))}
                  </Box>
                </FieldBlock>

                {selectedPatron ? (
                  <>
                    <InfoRow
                      icon="star"
                      label="Patron"
                      value={selectedPatron.name}
                    />
                    <InfoRow
                      icon="sun"
                      label="Domain"
                      value={selectedPatron.domain}
                    />
                    <FieldBlock label="About">
                      <Box style={{ whiteSpace: 'pre-line' }}>
                        {display(selectedPatron.description, 'No description.')}
                      </Box>
                    </FieldBlock>
                    <FieldBlock label="Boons">
                      <Box>{display(selectedPatron.boons)}</Box>
                    </FieldBlock>
                    <FieldBlock label="Sins">
                      <Box color="bad">{display(selectedPatron.sins)}</Box>
                    </FieldBlock>
                  </>
                ) : null}
              </Section>
            ) : (
              <Section fill>
                <Box color="label">No faiths available.</Box>
              </Section>
            )}
          </Stack.Item>
        </Stack>
      </Panel>
    );
  };

  const renderAncestryPicker = () => {
    const ancestryOptions = data.ancestry_options ?? [];
    const title = `Choose ${display(data.ancestry_label, 'Ancestry')}`;

    return (
      <Panel title={title} icon="leaf">
        <Section
          title={
            <Stack align="center">
              <Stack.Item>
                {display(data.ancestry_label, 'Ancestry')}
              </Stack.Item>
              <Stack.Item>
                <Box color="good">{display(data.ancestry_value)}</Box>
              </Stack.Item>
            </Stack>
          }
        >
          <Box style={{ display: 'flex', flexWrap: 'wrap', gap: '6px' }}>
            {ancestryOptions.length ? (
              ancestryOptions.map((option) => (
                <Button
                  key={option.value}
                  selected={asBool(option.selected)}
                  tooltip={option.name}
                  onClick={() =>
                    doPref('character_setup_select_ancestry', undefined, {
                      ancestry: option.value,
                    })
                  }
                  style={{ minWidth: '126px', padding: '6px' }}
                >
                  <Stack align="center">
                    <Stack.Item>
                      <Box
                        width="28px"
                        height="16px"
                        style={{ border: '1px solid rgba(0,0,0,0.65)' }}
                        backgroundColor={swatchColor(option.color)}
                      />
                    </Stack.Item>
                    <Stack.Item grow>
                      <Box textAlign="left" bold>
                        {option.name}
                      </Box>
                    </Stack.Item>
                  </Stack>
                </Button>
              ))
            ) : (
              <Box color="label">No ancestry choices available.</Box>
            )}
          </Box>
        </Section>
      </Panel>
    );
  };

  const renderSelectionPanel = () => {
    if (selectionMode === 'faith') {
      return renderFaithPicker();
    }
    if (selectionMode === 'ancestry') {
      return renderAncestryPicker();
    }
    return renderSpeciesPicker();
  };

  const renderIdentity = () => (
    <>
      <Stack>
        <Stack.Item grow basis={0}>
          <Panel title="Identity" icon="id-card">
            <PrefRow
              icon="signature"
              label="Name"
              value={data.real_name}
              onClick={() => doPref('name', 'input')}
            />
            <PrefRow
              icon="venus-mars"
              label="Body Type"
              value={data.gender}
              onClick={() => doPref('gender')}
            />
            <PrefRow
              icon="comment"
              label="Pronouns"
              value={data.pronouns}
              onClick={() => doPref('pronouns', 'input')}
            />
            <FieldBlock label="Age">
              <Tooltip
                content={catalog?.age_tooltips?.[data.age] ?? ''}
                position="bottom"
              >
                <Box>
                  <Dropdown
                    width="100%"
                    displayText={display(data.age)}
                    selected={display(data.age)}
                    options={ageOptions.map((option, index) => ({
                      displayText: display(option, option),
                      value: index + 1,
                    }))}
                    onSelected={(value) => act('set_age', { value })}
                  />
                </Box>
              </Tooltip>
            </FieldBlock>
            {renderSelectionModeButtons()}
          </Panel>
        </Stack.Item>

        <Stack.Item grow basis={0}>
          <Panel title="Standing" icon="sun">
            <PrefRow
              icon="hand-paper"
              label="Dominant Hand"
              value={data.domhand}
              onClick={() => doPref('domhand')}
            />
            <PrefRow
              icon="theater-masks"
              label="Quirks"
              value="Select"
              onClick={() => doPref('select_quirks')}
            />
            <InfoRow
              icon="award"
              label="Player Quality"
              value={data.player_quality}
              valueColor={data.player_quality_color || undefined}
            />
          </Panel>
        </Stack.Item>

        {data.lang !== 'en' ? (
          <Stack.Item grow basis={0}>
            <Panel title="Склонения" icon="spell-check">
              {DECLENSION_CASES.map((entry) => (
                <PrefRow
                  key={entry.key}
                  icon="signature"
                  label={entry.label}
                  tooltip={entry.tooltip}
                  value={data.declensions?.[entry.case] || '—'}
                  onClick={() => doPref(entry.key, 'input')}
                />
              ))}
            </Panel>
          </Stack.Item>
        ) : null}
      </Stack>

      {renderSelectionPanel()}
    </>
  );

  const renderColorSwatches = (feature: FeatureEntry) => (
    <Box style={{ display: 'flex', flexWrap: 'wrap', alignItems: 'center' }}>
      {(feature.colors || []).map((color) => (
        <Button
          key={color.index}
          mr={0.5}
          tooltip={color.name}
          onClick={() =>
            customizerAct(feature.key, 'acc_color', {
              color_index: color.index,
            })
          }
        >
          <Box
            inline
            width="22px"
            height="11px"
            verticalAlign="middle"
            backgroundColor={swatchColor(color.value)}
          />
        </Button>
      ))}
      <Button
        icon="undo"
        tooltip={tp('Reset colors')}
        onClick={() => customizerAct(feature.key, 'reset_colors')}
      />
    </Box>
  );

  const renderFeatureExtras = (feature: FeatureEntry) => {
    const extras = feature.extras || [];
    if (!extras.length) {
      return null;
    }

    return (
      <Box
        style={{
          display: 'flex',
          flexWrap: 'wrap',
          alignItems: 'center',
          gap: '4px 6px',
        }}
      >
        {extras.map((extra) => (
          <Box
            key={extra.task}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '4px',
            }}
          >
            <Box color="label" style={{ fontSize: '12px', lineHeight: '14px' }}>
              {extra.label}
            </Box>
            <Button
              compact
              tooltip={extra.label}
              onClick={() => customizerAct(feature.key, extra.task)}
            >
              {extra.kind === 'color' ? (
                <Box
                  inline
                  width="22px"
                  height="11px"
                  verticalAlign="middle"
                  backgroundColor={swatchColor(extra.value)}
                />
              ) : (
                display(extra.value)
              )}
            </Button>
          </Box>
        ))}
      </Box>
    );
  };

  const renderFeatureBody = (feature: FeatureEntry, skipColors?: boolean) => {
    const extraControls = renderFeatureExtras(feature);
    const choiceOptions = data.feature_choice_options?.[feature.key];
    const accessoryOptions = feature.accessory_value
      ? (data.feature_accessory_options?.[feature.choice_value ?? ''] ??
        resolveAccessoryOptions(
          catalog,
          feature.choice_value,
          data.species_id,
          data.gender_key,
        ))
      : undefined;

    return (
      <>
        {!skipColors && feature.colors?.length ? (
          <FieldBlock label="Colors">{renderColorSwatches(feature)}</FieldBlock>
        ) : null}

        {choiceOptions ? (
          <FieldBlock label="Type">
            <OptionGrid
              options={choiceOptions}
              selected={feature.choice_value}
              onSelect={(value) =>
                doPref('character_setup_set_choice', undefined, {
                  key: feature.key,
                  choice_type: value,
                })
              }
            />
          </FieldBlock>
        ) : null}

        {accessoryOptions ? (
          <Box mb={1}>
            <Stack align="center" mb={0.5}>
              <Stack.Item>
                <Box color="label">{tp('Style')}</Box>
              </Stack.Item>
              {extraControls ? (
                <Stack.Item grow>{extraControls}</Stack.Item>
              ) : null}
            </Stack>
            <OptionGrid
              options={accessoryOptions}
              selected={feature.accessory_value}
              onSelect={(value) =>
                customizerAct(feature.key, 'select_acc', { acc_type: value })
              }
              onHover={(v) =>
                requestHover(
                  v,
                  feature.colors?.[0]?.value ??
                    feature.extras?.find((e) => e.kind === 'color')?.value,
                  feature.key,
                )
              }
              spriteThumbs
            />
          </Box>
        ) : feature.accessory_name ? (
          <Box mb={1}>
            <Stack align="center" mb={0.5}>
              <Stack.Item>
                <Box color="label">{tp('Style')}</Box>
              </Stack.Item>
              {extraControls ? (
                <Stack.Item grow>{extraControls}</Stack.Item>
              ) : null}
            </Stack>
            <Box>{feature.accessory_name}</Box>
          </Box>
        ) : extraControls ? (
          <FieldBlock label="Options">{extraControls}</FieldBlock>
        ) : null}
      </>
    );
  };
  const renderFeatureEditor = (feature: FeatureEntry, showName?: boolean) => {
    const enabled = asBool(feature.enabled);
    return (
      <Box mb={1}>
        {showName || asBool(feature.can_disable) ? (
          <Stack align="center" mb={0.5}>
            {showName ? (
              <Stack.Item>
                <Box bold>{feature.name}</Box>
              </Stack.Item>
            ) : null}
            {asBool(feature.can_disable) ? (
              <Stack.Item>
                <Button
                  icon={enabled ? 'toggle-on' : 'toggle-off'}
                  selected={enabled}
                  onClick={() => customizerAct(feature.key, 'toggle_missing')}
                >
                  {enabled ? 'On' : 'Off'}
                </Button>
              </Stack.Item>
            ) : null}
          </Stack>
        ) : null}
        {enabled ? (
          renderFeatureBody(feature)
        ) : (
          <Box color="label">This feature is hidden.</Box>
        )}
      </Box>
    );
  };

  const renderTaurEditor = () => (
    <>
      <PrefRow
        icon="paw"
        label="Body"
        value={data.taur_body}
        onClick={() => doPref('character_setup_taur_body')}
      />
      <PrefRow
        icon="palette"
        label="Color"
        swatch={data.taur_color}
        value={data.taur_color}
        onClick={() =>
          doPref('character_setup_taur_color', undefined, { which: 'base' })
        }
      />
      <PrefRow
        icon="palette"
        label="Markings"
        swatch={data.taur_markings}
        value={data.taur_markings}
        onClick={() =>
          doPref('character_setup_taur_color', undefined, { which: 'markings' })
        }
      />
      <PrefRow
        icon="palette"
        label="Tertiary"
        swatch={data.taur_tertiary}
        value={data.taur_tertiary}
        onClick={() =>
          doPref('character_setup_taur_color', undefined, { which: 'tertiary' })
        }
      />
    </>
  );

  const renderBackdropEditor = () => (
    <FieldBlock label="Backdrop tile" labelSize="18px">
      <OptionGrid
        options={catalog?.background_options ?? []}
        selected={data.background}
        labelSize="15px"
        onSelect={(value) =>
          doPref('character_setup_preview_background', undefined, { bg: value })
        }
      />
    </FieldBlock>
  );

  const renderFeatureCard = (feature: FeatureEntry) => {
    const enabled = asBool(feature.enabled);
    return (
      <Section
        key={feature.key}
        mb={1}
        title={feature.name}
        buttons={
          asBool(feature.can_disable) ? (
            <Button
              icon={enabled ? 'toggle-on' : 'toggle-off'}
              selected={enabled}
              onClick={() => customizerAct(feature.key, 'toggle_missing')}
            >
              {enabled ? 'On' : 'Off'}
            </Button>
          ) : null
        }
      >
        {enabled ? renderFeatureBody(feature) : null}
      </Section>
    );
  };

  const renderUnderwearEditor = (features: FeatureEntry[]) => (
    <>
      {features.map((feature) => (
        <Fragment key={feature.key}>
          {renderFeatureEditor(feature, true)}
        </Fragment>
      ))}
    </>
  );

  const renderAppearance = () => {
    const appearanceFeatures = (data.features || []).filter(
      (feature) => !asBool(feature.erp),
    );
    const underwearFeatures = appearanceFeatures.filter(
      (feature) => feature.section === 'underwear',
    );
    const faceFeatures = appearanceFeatures.filter(
      (feature) =>
        feature.section !== 'underwear' && isFaceFeature(feature.key),
    );
    const otherFeatures = appearanceFeatures.filter(
      (feature) =>
        feature.section !== 'underwear' && !isFaceFeature(feature.key),
    );

    const featureTabs = [
      ...(underwearFeatures.length
        ? [{ key: UNDERWEAR_KEY, name: 'Underwear' }]
        : []),
      ...(faceFeatures.length ? [{ key: FACE_KEY, name: 'Face Details' }] : []),
      ...otherFeatures.map((feature) => ({
        key: feature.key,
        name: feature.name,
      })),
      ...(asBool(data.is_taur) ? [{ key: TAUR_KEY, name: 'Taur Body' }] : []),
      { key: BACKDROP_KEY, name: 'Backdrop' },
    ];
    const currentKey = featureTabs.some((tab) => tab.key === activeFeature)
      ? activeFeature
      : featureTabs[0]?.key;

    const renderEditor = () => {
      if (currentKey === UNDERWEAR_KEY) {
        return renderUnderwearEditor(underwearFeatures);
      }
      if (currentKey === BACKDROP_KEY) {
        return renderBackdropEditor();
      }
      if (currentKey === TAUR_KEY) {
        return renderTaurEditor();
      }
      if (currentKey === FACE_KEY) {
        if (!faceFeatures.length) {
          return <Box color="label">No face details for this species.</Box>;
        }
        return faceFeatures.map((feature) => (
          <Fragment key={feature.key}>
            {renderFeatureEditor(feature, true)}
          </Fragment>
        ));
      }
      const feature = otherFeatures.find((entry) => entry.key === currentKey);
      if (!feature) {
        return (
          <Box color="label">No customization available for this species.</Box>
        );
      }
      return renderFeatureEditor(feature, false);
    };

    return (
      <Panel title="Appearance" icon="palette">
        <Box style={{ display: 'flex', flexWrap: 'wrap' }} mb={1}>
          {featureTabs.map((tab) => (
            <Button
              key={tab.key}
              mr={0.5}
              mb={0.5}
              selected={tab.key === currentKey}
              onClick={() => setActiveFeature(tab.key)}
            >
              {tab.name}
            </Button>
          ))}
        </Box>
        <Section>{renderEditor()}</Section>
      </Panel>
    );
  };

  const renderVoice = () => (
    <Panel title="Voice" icon="volume-up">
      <PrefRow
        icon="microphone"
        label="Voice Type"
        value={data.voice_type}
        onClick={() => doPref('voicetype', 'input')}
      />
      <PrefRow
        icon="comment-dots"
        label="Accent"
        value={data.selected_accent}
        onClick={() => doPref('selected_accent', 'input')}
      />
      <PrefRow
        icon="tint"
        label="Voice Color"
        swatch={data.voice_color}
        value={data.voice_color}
        onClick={() => doPref('voice', 'input')}
      />
    </Panel>
  );

  const renderBackground = () => (
    <>
      <Panel title="Flavour" icon="scroll">
        <PrefRow
          icon="align-left"
          label="Flavour Text"
          value="Edit"
          onClick={() => doPref('flavortext', 'input')}
        />
        <PrefRow
          icon="tags"
          label="Descriptors"
          value="Edit"
          onClick={() => doPref('descriptors', 'menu')}
        />
        <PrefRow
          icon="map"
          label="Culture"
          value={data.culture_name}
          onClick={() => doPref('culture', 'input')}
        />
        <PrefRow
          icon="utensils"
          label="Food Preferences"
          value="Edit"
          onClick={() => doPref('culinary', 'menu')}
        />
      </Panel>

      <Panel title="Relations" icon="users">
        <PrefRow
          icon="home"
          label="Family"
          value={data.family}
          onClick={() => doPref('family')}
        />
        <PrefRow
          icon="heart"
          label="Spouse Pref"
          value={data.spouse}
          onClick={() => doPref('setspouse')}
        />
        <PrefRow
          icon="venus-mars"
          label="Gender Pref"
          value={data.gender_pref}
          onClick={() => doPref('gender_choice')}
        />
      </Panel>

      <Panel title="OOC" icon="sticky-note">
        <PrefRow
          icon="sticky-note"
          label="OOC Notes"
          value="Edit"
          onClick={() => doPref('ooc_notes', 'input')}
        />
        <PrefRow
          icon="paperclip"
          label="OOC Extra"
          value="Edit"
          onClick={() => doPref('ooc_extra', 'input')}
        />
      </Panel>
    </>
  );

  const renderGameplay = () => (
    <>
      <Panel title="Class & Roles" icon="shield-alt">
        <PrefRow
          icon="briefcase"
          label="Class / Jobs"
          value={data.high_job}
          onClick={() => doPref('job', 'menu')}
        />
        <PrefRow
          icon="list-ol"
          label="Ready Order"
          value="Edit"
          onClick={() => doPref('multi', 'menu')}
        />
        <InfoRow icon="star" label="Special Role" value={data.special_role} />
        <ActionButton
          icon="user-secret"
          label="Special Roles"
          onClick={() => doPref('antag', 'menu')}
        />
      </Panel>

      <Panel title="Loadout" icon="shopping-bag">
        {loadouts.map((slot) => (
          <PrefRow
            key={slot.slot}
            icon="box"
            label={`Slot ${slot.slot}`}
            value={slot.name}
            onClick={() =>
              doPref('loadout_item', 'input', { loadout_number: slot.slot })
            }
          />
        ))}
      </Panel>

      <Panel title="Triumphs" icon="trophy">
        <InfoRow icon="coins" label="Balance" value={data.triumphs} />
        <ActionButton
          icon="shopping-bag"
          label="Triumph Shop"
          onClick={() => doPref('triumph_buy_menu')}
        />
        <ActionButton
          icon="shirt"
          label="Лодаут"
          onClick={() => doPref('donor_loadout')}
        />
      </Panel>
    </>
  );

  const renderProfile = () => (
    <Panel title="Profile Link" icon="image">
      <Box textAlign="center" mb={1}>
        {data.headshot ? (
          <img
            src={data.headshot}
            alt=""
            style={{ maxWidth: '100%', maxHeight: '320px' }}
          />
        ) : (
          <Box py={3} color="label">
            <Icon name="user" size={4} />
            <Box mt={1}>{tp('No headshot set')}</Box>
          </Box>
        )}
      </Box>
      <ActionButton
        icon="link"
        label="Set Headshot URL"
        onClick={() => doPref('headshot', 'input')}
      />
    </Panel>
  );

  const renderErp = () => {
    const erpFeatures = (data.features || []).filter((feature) =>
      asBool(feature.erp),
    );
    return (
      <>
        <Section mb={1}>
          <Stack align="center">
            <Stack.Item grow>
              <Box>
                Intimacy opt-in is{' '}
                <Box as="span" bold color={erpEnabled ? 'good' : 'bad'}>
                  {erpEnabled ? 'ENABLED' : 'DISABLED'}
                </Box>
                . Toggle it in{' '}
                <Button
                  inline
                  compact
                  icon="cog"
                  onClick={() => setActiveSection('settings')}
                >
                  Settings
                </Button>
                .
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="key"
                disabled={!erpEnabled}
                onClick={() => doPref('character_setup_erp_panel')}
              >
                Open Intimacy Panel
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
        {erpFeatures.length ? (
          <Stack>
            <Stack.Item grow basis={0}>
              {erpFeatures
                .filter((_, index) => index % 2 === 0)
                .map(renderFeatureCard)}
            </Stack.Item>
            <Stack.Item grow basis={0}>
              {erpFeatures
                .filter((_, index) => index % 2 === 1)
                .map(renderFeatureCard)}
            </Stack.Item>
          </Stack>
        ) : (
          <Section>
            <Box color="label">
              No intimate customization available for this species.
            </Box>
          </Section>
        )}
      </>
    );
  };

  const renderOocChatPanel = () => {
    const messages = [...(data.ooc_messages ?? [])].reverse();

    return (
      <Box mt={1}>
        <Stack align="center" mb={0.5}>
          <Stack.Item>
            <Icon name="comments" />
          </Stack.Item>
          <Stack.Item grow>
            <Box bold>OOC Chat</Box>
          </Stack.Item>
          <Stack.Item>
            <Button
              compact
              icon={oocExpanded ? 'compress' : 'expand'}
              tooltip={oocExpanded ? 'Compact OOC chat' : 'Expand OOC chat'}
              onClick={() => setOocExpanded(!oocExpanded)}
            />
          </Stack.Item>
        </Stack>
        <Box
          mb={0.5}
          p={0.5}
          style={{
            height: oocExpanded ? '150px' : '76px',
            minHeight: '56px',
            maxHeight: '480px',
            resize: 'vertical',
            overflowY: 'auto',
            border: '1px solid rgba(255,255,255,0.18)',
            backgroundColor: 'rgba(0,0,0,0.22)',
          }}
        >
          {messages.length ? (
            messages.map((entry, index) => (
              <Box key={`${entry.time}-${entry.sender}-${index}`} mb={0.75}>
                <Box
                  color="label"
                  style={{ fontSize: '10px', lineHeight: '12px' }}
                >
                  {display(entry.time, '--:--')} {display(entry.sender, 'OOC')}
                </Box>
                <Box
                  style={{
                    fontSize: '11px',
                    lineHeight: '13px',
                    overflowWrap: 'anywhere',
                  }}
                >
                  {display(entry.message)}
                </Box>
              </Box>
            ))
          ) : (
            <Box color="label" textAlign="center" mt={1}>
              {tp('No OOC messages.')}
            </Box>
          )}
        </Box>
        <TextArea
          fluid
          height="42px"
          maxLength={1024}
          placeholder={tp('Message OOC...')}
          value={oocMessage}
          onChange={(value: string) => setOocMessage(value)}
        />
        <Button
          fluid
          compact
          mt={0.5}
          icon="paper-plane"
          color="green"
          disabled={!oocMessage.trim()}
          onClick={sendOocMessage}
        >
          {tp('Send OOC')}
        </Button>
      </Box>
    );
  };

  const bounds = data.tgui_text_bounds ?? {
    font_min: 10,
    font_max: 20,
    font_default: 14,
    line_min: 100,
    line_max: 220,
    line_step: 5,
    line_default: 120,
  };

  // Null means "whatever the theme says", so the button shows Theme and clicking
  // it sends no value at all, which is what the backend reads back as null.
  const textStepper = (props: {
    icon: string;
    label: string;
    value: number | null;
    fallback: number;
    min: number;
    max: number;
    step: number;
    unit: string;
    send: (value: number) => void;
    reset: () => void;
  }) => {
    const current = props.value ?? props.fallback;
    return (
      <Stack align="center" mt={0.5}>
        <Stack.Item>
          <Icon name={props.icon} />
        </Stack.Item>
        <Stack.Item grow>
          <Box color="label">{tp(props.label)}</Box>
        </Stack.Item>
        <Stack.Item>
          <Button
            compact
            icon="minus"
            disabled={current <= props.min}
            onClick={() => props.send(current - props.step)}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            compact
            tooltip={tp('Back to the theme default')}
            onClick={props.reset}
          >
            {props.value === null ? tp('Theme') : `${props.value}${props.unit}`}
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            compact
            icon="plus"
            disabled={current >= props.max}
            onClick={() => props.send(current + props.step)}
          />
        </Stack.Item>
      </Stack>
    );
  };

  const renderSettings = () => {
    const game = data.game_prefs || ({} as PrefsData['game_prefs']);
    const toggle = (preference: string) => doPref(preference);

    return (
      <>
        <Panel title="Interface" icon="desktop">
          <PrefRow
            icon="language"
            label="Язык / Language"
            value={game.language}
            onClick={() => toggle('language')}
          />
          <PrefRow
            icon="keyboard"
            label="Hotkeys"
            value={asBool(game.hotkeys) ? 'ON' : 'OFF'}
            selected={asBool(game.hotkeys)}
            onClick={() => toggle('hotkeys')}
          />
          <PrefRow
            icon="mouse-pointer"
            label="Action Buttons"
            value={asBool(game.buttons_locked) ? 'Locked' : 'Unlocked'}
            selected={asBool(game.buttons_locked)}
            onClick={() => toggle('action_buttons')}
          />
          <PrefRow
            icon="window-restore"
            label="Fancy tgui"
            value={asBool(game.tgui_fancy) ? 'ON' : 'OFF'}
            selected={asBool(game.tgui_fancy)}
            onClick={() => toggle('tgui_fancy')}
          />
          <PrefRow
            icon="lock"
            label="Lock tgui Layout"
            value={asBool(game.tgui_lock) ? 'ON' : 'OFF'}
            selected={asBool(game.tgui_lock)}
            onClick={() => toggle('tgui_lock')}
          />
          <PrefRow
            icon="bolt"
            label="Window Flashing"
            value={asBool(game.windowflashing) ? 'ON' : 'OFF'}
            selected={asBool(game.windowflashing)}
            onClick={() => toggle('winflash')}
          />
        </Panel>

        <Panel title="Interface Theme" icon="palette">
          <Box style={{ display: 'flex', flexWrap: 'wrap', gap: '4px' }}>
            {(catalog?.tgui_themes ?? []).map((t) => (
              <Button
                key={t.value}
                selected={data.tgui_theme === t.value}
                onClick={() =>
                  doPref('character_setup_tgui_theme', undefined, {
                    theme: t.value,
                  })
                }
              >
                {t.label}
              </Button>
            ))}
          </Box>
          {textStepper({
            icon: 'text-height',
            label: 'Font Size',
            value: data.tgui_font_size,
            fallback: bounds.font_default,
            min: bounds.font_min,
            max: bounds.font_max,
            step: 1,
            unit: 'px',
            send: (size) =>
              doPref('character_setup_tgui_font_size', undefined, { size }),
            reset: () => doPref('character_setup_tgui_font_size'),
          })}
          {textStepper({
            icon: 'align-justify',
            label: 'Line Spacing',
            value: data.tgui_line_height,
            fallback: bounds.line_default,
            min: bounds.line_min,
            max: bounds.line_max,
            step: bounds.line_step,
            unit: '%',
            send: (height) =>
              doPref('character_setup_tgui_line_height', undefined, { height }),
            reset: () => doPref('character_setup_tgui_line_height'),
          })}
        </Panel>

        <Panel title="Display" icon="eye">
          <PrefRow
            icon="comments"
            label="See Non-mob Chat"
            value={asBool(game.see_chat_non_mob) ? 'ON' : 'OFF'}
            selected={asBool(game.see_chat_non_mob)}
            onClick={() => toggle('see_chat_non_mob')}
          />
          <PrefRow
            icon="sun"
            label="Ambient Occlusion"
            value={asBool(game.ambientocclusion) ? 'ON' : 'OFF'}
            selected={asBool(game.ambientocclusion)}
            onClick={() => toggle('ambientocclusion')}
          />
          <PrefRow
            icon="expand"
            label="Auto-fit Viewport"
            value={asBool(game.auto_fit_viewport) ? 'ON' : 'OFF'}
            selected={asBool(game.auto_fit_viewport)}
            onClick={() => toggle('auto_fit_viewport')}
          />
          <PrefRow
            icon="tv"
            label="Widescreen"
            value={asBool(game.widescreenpref) ? 'ON' : 'OFF'}
            selected={asBool(game.widescreenpref)}
            onClick={() => toggle('widescreenpref')}
          />
          <PrefRow
            icon="search-plus"
            label="Pixel Size"
            value={game.pixel_size}
            onClick={() => toggle('pixel_size')}
          />
          <PrefRow
            icon="image"
            label="Scaling Method"
            value={game.scaling_method}
            onClick={() => toggle('scaling_method')}
          />
        </Panel>

        <Panel title="Audio & Round" icon="volume-up">
          <PrefRow
            icon="music"
            label="Lobby Music"
            value={asBool(game.lobby_music) ? 'ON' : 'OFF'}
            selected={asBool(game.lobby_music)}
            onClick={() => toggle('lobby_music')}
          />
          <PrefRow
            icon="music"
            label="Admin MIDIs"
            value={asBool(game.hear_midis) ? 'ON' : 'OFF'}
            selected={asBool(game.hear_midis)}
            onClick={() => toggle('hear_midis')}
          />
          <PrefRow
            icon="user-secret"
            label="Midround Antag"
            value={asBool(game.allow_midround_antag) ? 'ON' : 'OFF'}
            selected={asBool(game.allow_midround_antag)}
            onClick={() => toggle('allow_midround_antag')}
          />
        </Panel>

        <Panel title="Intimacy & Tools" icon="sliders-h">
          <PrefRow
            icon="heart"
            label="Intimacy Opt-in (ERP)"
            value={erpEnabled ? 'ON' : 'OFF'}
            selected={erpEnabled}
            onClick={() => doPref('character_setup_erp_toggle')}
          />
          <ActionButton
            icon="toggle-on"
            label="Toggle Bitfields"
            onClick={() => doPref('toggles')}
          />
          <ActionButton
            icon="keyboard"
            label="Keybinds"
            onClick={() => doPref('keybinds', 'menu')}
          />
          <ActionButton
            icon="save"
            label="Save Preferences"
            color="blue"
            onClick={() => doPref('save')}
          />
        </Panel>
      </>
    );
  };

  const renderActiveSection = () => {
    switch (activeSection) {
      case 'appearance':
        return renderAppearance();
      case 'gameplay':
        return renderGameplay();
      case 'profile':
        return (
          <>
            {renderVoice()}
            {renderBackground()}
            {renderProfile()}
          </>
        );
      case 'erp':
        return renderErp();
      case 'settings':
        return renderSettings();
      default:
        return renderIdentity();
    }
  };

  const NavTab = (section: { id: string; label: string; icon: string }) => (
    <Tabs.Tab
      key={section.id}
      icon={section.icon}
      selected={activeSection === section.id}
      onClick={() => setActiveSection(section.id)}
    >
      {tp(section.label)}
    </Tabs.Tab>
  );

  const FooterSummary = (props: {
    icon: string;
    label: string;
    value?: unknown;
    onClick: () => void;
  }) => (
    <Button
      color="transparent"
      onClick={props.onClick}
      tooltip={tp(props.label)}
    >
      <Stack align="center">
        <Stack.Item>
          <Icon name={props.icon} />
        </Stack.Item>
        <Stack.Item>
          <Box color="label" fontSize="10px">
            {tp(props.label)}
          </Box>
          <Box bold>{display(tp(props.value))}</Box>
        </Stack.Item>
      </Stack>
    </Button>
  );

  const renderRoundStartReport = () => (
    <Section title={tp('Round Start')} mb={1}>
      <Box bold fontSize="22px" color={roundStatusColor}>
        {roundCountdown}
      </Box>
      <Box color="label" mb={0.5}>
        {tp(roundStatus)}
      </Box>
      <Button
        fluid
        mb={0.75}
        icon={data.round_action_icon || 'user-check'}
        color={data.round_action_color || undefined}
        disabled={asBool(data.round_action_disabled)}
        tooltip={data.round_action_tooltip || data.round_action_label}
        onClick={() => doPref('character_setup_round_action')}
      >
        {display(data.round_action_label)}
      </Button>
      <Stack align="center">
        <Stack.Item>
          <Icon name="user-check" />
        </Stack.Item>
        <Stack.Item grow>
          <Box color="label">{tp('Ready')}</Box>
        </Stack.Item>
        <Stack.Item>
          <Box bold>
            {display(data.round_ready_players, '0')} /{' '}
            {display(data.round_total_players, '0')}
          </Box>
        </Stack.Item>
      </Stack>
    </Section>
  );

  const renderWindowControls = () => (
    <Stack align="center">
      <Stack.Item>
        <Button
          compact
          icon="search-minus"
          tooltip={tp('Smaller elements')}
          disabled={menuScale <= 0.8}
          onClick={() => setMenuScale(menuScale - 0.05)}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          compact
          tooltip={tp('Reset element scale')}
          onClick={() => setMenuScale(0.85)}
        >
          {Math.round(menuScale * 100)}%
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          compact
          icon="search-plus"
          tooltip={tp('Larger elements')}
          disabled={menuScale >= 1.25}
          onClick={() => setMenuScale(menuScale + 0.05)}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          compact
          icon={isFullscreen ? 'compress' : 'expand'}
          tooltip={isFullscreen ? 'Collapse window' : 'Expand window'}
          onClick={() => doPref('character_setup_preferences_fullscreen')}
        />
      </Stack.Item>
    </Stack>
  );

  return (
    <Window
      title={tp('Character Setup')}
      width={windowWidth}
      height={windowHeight}
      theme={data.tgui_theme || 'vibelin'}
      buttons={renderWindowControls()}
    >
      <Window.Content>
        <Box height="100%" style={scaledContentStyle}>
          <Stack vertical fill>
            <Stack.Item>
              <Section>
                <Stack align="center">
                  <Stack.Item grow>
                    <Box bold fontSize="18px">
                      {display(data.real_name, tp('Unnamed'))}
                    </Box>
                    <Box color="label">{headerMeta}</Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="exchange-alt"
                      onClick={() => doPref('changeslot')}
                    >
                      {tp('Change Character')}
                    </Button>
                  </Stack.Item>
                </Stack>
              </Section>
            </Stack.Item>

            <Stack.Item grow>
              <Stack fill>
                <Stack.Item basis="210px">
                  <Stack vertical fill>
                    <Stack.Item>{renderRoundStartReport()}</Stack.Item>
                    <Stack.Item grow>
                      <Section fill scrollable>
                        <Tabs vertical>
                          {charSections.map(NavTab)}
                          <Box
                            my={1}
                            mx={1}
                            height="1px"
                            backgroundColor="rgba(255,255,255,0.15)"
                          />
                          {systemSections.map(NavTab)}
                        </Tabs>
                        {renderOocChatPanel()}
                      </Section>
                    </Stack.Item>
                    {data.preview_map_front && data.preview_map_side ? (
                      <Stack.Item>
                        <Stack>
                          <Stack.Item grow basis={0}>
                            <div
                              ref={frontBoxRef}
                              style={{
                                position: 'relative',
                                width: '100%',
                                aspectRatio: '1 / 1',
                                backgroundColor: backdropColor || '#0d0d0d',
                              }}
                            >
                              {previewMiniZoom > 0 ? (
                                <ByondMapView
                                  key={data.preview_map_front}
                                  style={{ width: '100%', height: '100%' }}
                                  deps={[
                                    menuScale,
                                    data.preferences_fullscreen,
                                  ]}
                                  params={{
                                    id: data.preview_map_front,
                                    type: 'map',
                                    zoom: previewMiniZoom,
                                    'zoom-mode': 'distort',
                                    'background-color':
                                      backdropColor || '#0d0d0d',
                                  }}
                                />
                              ) : null}
                            </div>
                            <Box
                              color="label"
                              textAlign="center"
                              style={{ fontSize: '10px', lineHeight: '14px' }}
                            >
                              {tp('Front')}
                            </Box>
                          </Stack.Item>
                          <Stack.Item grow basis={0}>
                            <div
                              ref={sideBoxRef}
                              style={{
                                position: 'relative',
                                width: '100%',
                                aspectRatio: '1 / 1',
                                backgroundColor: backdropColor || '#0d0d0d',
                              }}
                            >
                              {previewMiniZoom > 0 ? (
                                <ByondMapView
                                  key={data.preview_map_side}
                                  style={{ width: '100%', height: '100%' }}
                                  deps={[
                                    menuScale,
                                    data.preferences_fullscreen,
                                  ]}
                                  params={{
                                    id: data.preview_map_side,
                                    type: 'map',
                                    zoom: previewMiniZoom,
                                    'zoom-mode': 'distort',
                                    'background-color':
                                      backdropColor || '#0d0d0d',
                                  }}
                                />
                              ) : null}
                            </div>
                            <Box
                              color="label"
                              textAlign="center"
                              style={{ fontSize: '10px', lineHeight: '14px' }}
                            >
                              {tp('Side')}
                            </Box>
                          </Stack.Item>
                        </Stack>
                      </Stack.Item>
                    ) : null}
                  </Stack>
                </Stack.Item>

                <Stack.Item basis={`${174 * previewScale}px`}>
                  <Section title={tp('Looking Glass')}>
                    <Stack vertical>
                      <Stack.Item>
                        <Box
                          style={{
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                            height: '100%',
                            width: '100%',
                          }}
                        >
                          <div
                            ref={dollBoxRef}
                            style={{
                              position: 'relative',
                              width: '82%',
                              aspectRatio: '0.82 / 1',
                              maxHeight: '100%',
                              backgroundColor: backdropColor || '#0d0d0d',
                            }}
                          >
                            {data.preview_map && previewZoom > 0 ? (
                              <ByondMapView
                                key={data.preview_map}
                                style={{ width: '100%', height: '100%' }}
                                deps={[
                                  menuScale,
                                  previewScale,
                                  data.preferences_fullscreen,
                                ]}
                                params={{
                                  id: data.preview_map,
                                  type: 'map',
                                  zoom: previewZoom,
                                  'zoom-mode': 'distort',
                                  'background-color':
                                    backdropColor || '#0d0d0d',
                                }}
                              />
                            ) : (
                              <Box
                                style={{
                                  position: 'absolute',
                                  top: 0,
                                  left: 0,
                                  width: '100%',
                                  height: '100%',
                                  display: 'flex',
                                  alignItems: 'center',
                                  justifyContent: 'center',
                                }}
                              >
                                <Icon name="user" size={6} color="label" />
                              </Box>
                            )}
                          </div>
                        </Box>
                      </Stack.Item>
                      <Stack.Item>
                        <Stack mb={0.5}>
                          <Stack.Item grow>
                            <Button
                              fluid
                              textAlign="center"
                              icon="arrow-left"
                              tooltip={tp('Rotate left')}
                              onClick={() =>
                                doPref(
                                  'character_setup_preview_rotate',
                                  undefined,
                                  { rotate: 'left' },
                                )
                              }
                            />
                          </Stack.Item>
                          <Stack.Item>
                            <Box color="label" style={{ lineHeight: '24px' }}>
                              {tp('Rotate')}
                            </Box>
                          </Stack.Item>
                          <Stack.Item grow>
                            <Button
                              fluid
                              textAlign="center"
                              icon="arrow-right"
                              tooltip={tp('Rotate right')}
                              onClick={() =>
                                doPref(
                                  'character_setup_preview_rotate',
                                  undefined,
                                  { rotate: 'right' },
                                )
                              }
                            />
                          </Stack.Item>
                        </Stack>
                        <Button
                          fluid
                          mb={0.5}
                          icon={
                            asBool(data.preview_underwear)
                              ? 'check-square'
                              : 'square'
                          }
                          selected={asBool(data.preview_underwear)}
                          onClick={() =>
                            doPref('character_setup_preview_layer', undefined, {
                              layer: 'underwear',
                            })
                          }
                        >
                          {tp('Underwear Layer')}
                        </Button>
                        <Button
                          fluid
                          mb={0.5}
                          icon={
                            asBool(data.preview_clothes)
                              ? 'check-square'
                              : 'square'
                          }
                          selected={asBool(data.preview_clothes)}
                          onClick={() =>
                            doPref('character_setup_preview_layer', undefined, {
                              layer: 'clothes',
                            })
                          }
                        >
                          {tp('Work Clothes Layer')}
                        </Button>
                        <Button
                          fluid
                          icon="dice"
                          onClick={() => doPref('randomiseappearanceprefs')}
                        >
                          {tp('Randomise Appearance')}
                        </Button>
                        <Stack mt={0.5}>
                          <Stack.Item>
                            <Button
                              icon="arrow-left"
                              disabled={previewScale <= 1}
                              tooltip={tp('Zoom out')}
                              onClick={() => setPreviewScale(previewScale - 1)}
                            />
                          </Stack.Item>
                          <Stack.Item grow>
                            <Box
                              color="label"
                              textAlign="center"
                              style={{ lineHeight: '24px' }}
                            >
                              {tp('Zoom')} {previewScale}x
                            </Box>
                          </Stack.Item>
                          <Stack.Item>
                            <Button
                              icon="arrow-right"
                              disabled={previewScale >= 3}
                              tooltip={tp('Zoom in')}
                              onClick={() => setPreviewScale(previewScale + 1)}
                            />
                          </Stack.Item>
                        </Stack>
                      </Stack.Item>
                    </Stack>
                  </Section>
                </Stack.Item>

                <Stack.Item grow basis={0}>
                  <Section fill scrollable>
                    {renderActiveSection()}
                  </Section>
                </Stack.Item>
              </Stack>
            </Stack.Item>

            <Stack.Item>
              <Section>
                <Stack align="center">
                  <Stack.Item grow>
                    <Stack>
                      <Stack.Item>
                        <FooterSummary
                          icon="shield-alt"
                          label="Class"
                          value={data.high_job}
                          onClick={() => setActiveSection('gameplay')}
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <FooterSummary
                          icon="trophy"
                          label="Triumphs"
                          value={data.triumphs}
                          onClick={() => setActiveSection('gameplay')}
                        />
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="dice"
                      tooltip={tp('Randomise Appearance')}
                      onClick={() => doPref('randomiseappearanceprefs')}
                    >
                      {tp('Randomise')}
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="undo"
                      tooltip={tp('Undo from save')}
                      onClick={() => doPref('load')}
                    >
                      {tp('Undo')}
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="save"
                      color="blue"
                      tooltip={tp('Save')}
                      onClick={() => doPref('save')}
                    >
                      {tp('Save')}
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="check"
                      color="green"
                      tooltip={tp('Done')}
                      onClick={() => doPref('finished')}
                    >
                      {tp('Done')}
                    </Button>
                  </Stack.Item>
                </Stack>
              </Section>
            </Stack.Item>
          </Stack>
        </Box>
      </Window.Content>
    </Window>
  );
};

export default PreferencesMenu;
