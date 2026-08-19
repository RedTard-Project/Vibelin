import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Input,
  ProgressBar,
  Stack,
  Tabs,
} from 'tgui-core/components';

type SelectedItem = {
  path: string;
  name: string;
};

type Item = {
  name: string;
  path: string;
  iconClass: string;
  isDonatorItem: boolean | number;
  unavailableReason?: string | null;
};

type SlotTier = {
  tier: number;
  slots: number;
};

type Data = {
  categories: Record<string, Item[]>;
  selectedLoadoutItems: SelectedItem[];
  curLoadoutSlots: number;
  maxLoadoutSlots: number;
  slotTiers: SlotTier[];
};

const HELP_TEXT = `Выберите предметы для вашего персонажа.
Вы их сможете забрать из тайника (STASH) — нажмите правой кнопкой мыши по статуе или дереву.
Рескины на броню (Morphing Elixir) являются зельями: используйте зелье на соответствующем предмете, чтобы получить облик.`;

const RESET_CONFIRM_TIMEOUT = 5000;

const TILE_BORDER_UNAVAILABLE = '#a77a18';
const TILE_BORDER_SELECTED = '#a71818';
const TILE_BORDER_FREE = '#24a718';

const tierStyle = {
  minWidth: '0',
  width: 'auto',
  height: 'auto',
  padding: '0',
  border: 'none',
  boxShadow: 'none',
  background: 'none',
  lineHeight: 'inherit',
  verticalAlign: 'baseline',
  color: '#facc15',
  fontWeight: 'bold',
  cursor: 'help',
} as const;

const helpButtonStyle = {
  position: 'fixed',
  top: '9px',
  left: '92px',
  zIndex: 103,
  minWidth: '0',
  width: '16px',
  height: '16px',
  padding: '0',
  border: 'none',
  boxShadow: 'none',
  background: 'none',
  textAlign: 'center',
  lineHeight: '16px',
  fontSize: '13px',
  fontWeight: 'bold',
  color: '#d7b6b6',
  textShadow: '0 0 4px rgba(255,255,255,0.35)',
  cursor: 'help',
} as const;

const selectedBoxStyle = {
  minHeight: '200px',
  maxHeight: '260px',
  overflowY: 'auto',
  overflowX: 'hidden',
  padding: '8px',
  border: '1px solid rgba(120, 150, 190, 0.65)',
  borderRadius: '6px',
  backgroundColor: 'rgba(0, 0, 0, 0.14)',
} as const;

const gridStyle = {
  display: 'grid',
  gridTemplateColumns: 'repeat(auto-fill, minmax(96px, 1fr))',
  gap: '8px',
} as const;

const SlotTierLegend = (props: { tiers: SlotTier[] }) => (
  <Box
    mt={1}
    style={{
      fontSize: '13px',
      lineHeight: 1.35,
      textAlign: 'center',
      color: '#d7b6b6',
    }}
  >
    Для меценатов в зависимости от уровня подписки(
    {props.tiers.map((tier, index) => (
      <span key={tier.tier}>
        {index > 0 ? ', ' : ''}
        <Button
          tooltip={`Т${tier.tier} - дает ${tier.slots} слотов вещей.`}
          tooltipPosition="bottom"
          style={tierStyle}
        >
          {tier.tier}
        </Button>
      </span>
    ))}
    ) открываются различные бонусы в лодауте и не только. Лишь за счет поддержки
    сервер существует.
  </Box>
);

const ItemTile = (props: {
  item: Item;
  selected: boolean;
  onToggle: () => void;
}) => {
  const { item, selected, onToggle } = props;
  const borderColor = item.unavailableReason
    ? TILE_BORDER_UNAVAILABLE
    : selected
      ? TILE_BORDER_SELECTED
      : TILE_BORDER_FREE;

  return (
    <Box
      style={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        minWidth: '96px',
        minHeight: '64px',
      }}
    >
      <Button
        style={{
          backgroundColor: '#141414',
          padding: '16px',
          width: '96px',
          height: '96px',
          borderColor: borderColor,
          borderRadius: '8px',
        }}
        tooltip={item.unavailableReason || item.name}
        onClick={onToggle}
      >
        <Box
          inline
          verticalAlign="middle"
          className={item.iconClass}
          style={{ transform: 'scale(0.67) translate(-51px, -50px)' }}
        >
          {item.isDonatorItem ? (
            <Box
              style={{
                width: '100%',
                marginTop: '96px',
                fontSize: '20px',
                fontWeight: 'bold',
                color: '#c084fc',
                textAlign: 'center',
                textShadow: '1px 1px 3px rgba(0,0,0,0.75)',
                lineHeight: 1.2,
              }}
            >
              Донат
            </Box>
          ) : null}
        </Box>
      </Button>
    </Box>
  );
};

export const LoadoutPanel = () => {
  const { data, act } = useBackend<Data>();
  const [tabIndex, setTabIndex] = useState(0);
  const [searchQuery, setSearchQuery] = useState('');
  const [confirmReset, setConfirmReset] = useState(false);

  const selectedItems = data.selectedLoadoutItems ?? [];
  const selectedPaths = new Set(selectedItems.map((item) => item.path));

  const categories = Object.entries(data.categories ?? {}).map(
    ([name, items]) => ({ name, items }),
  );
  const activeTab = Math.min(tabIndex, Math.max(categories.length - 1, 0));
  const search = searchQuery.toLowerCase();
  const visibleItems = (categories[activeTab]?.items ?? []).filter((item) =>
    item.name.toLowerCase().includes(search),
  );

  const handleResetClick = () => {
    if (confirmReset) {
      act('clear');
      setConfirmReset(false);
      return;
    }
    setConfirmReset(true);
    setTimeout(() => setConfirmReset(false), RESET_CONFIRM_TIMEOUT);
  };

  const slotRatio =
    data.maxLoadoutSlots > 0 ? data.curLoadoutSlots / data.maxLoadoutSlots : 0;

  return (
    <Window
      title="Лодаут"
      buttons={
        <Button
          tooltip={HELP_TEXT}
          tooltipPosition="bottom"
          style={helpButtonStyle}
        >
          ?
        </Button>
      }
      width={1200}
      height={700}
    >
      <Window.Content>
        <Stack fill>
          <Stack.Item width="300px">
            <Stack vertical textAlign="justify">
              <Stack.Item style={{ textAlign: 'center' }}>
                <Button onClick={() => act('boosty')}>
                  <h3>Поддержать сервер</h3>
                </Button>
              </Stack.Item>
              <Stack.Item>
                <SlotTierLegend tiers={data.slotTiers ?? []} />
              </Stack.Item>
              <Stack.Item>
                {data.curLoadoutSlots} / {data.maxLoadoutSlots}
              </Stack.Item>
              <Stack.Item>
                <ProgressBar
                  ranges={{
                    bad: [0.75, Infinity],
                    average: [0.25, 0.75],
                    good: [-Infinity, 0.25],
                  }}
                  value={slotRatio}
                  width="100%"
                />
              </Stack.Item>
              <Stack.Item>
                <Box mt={2} style={selectedBoxStyle}>
                  <Box
                    mb={1}
                    textAlign="center"
                    style={{
                      fontSize: '16px',
                      fontWeight: 'bold',
                      textShadow: '1px 1px 3px rgba(0,0,0,0.8)',
                    }}
                  >
                    Выбранные предметы:
                  </Box>
                  {selectedItems.length ? (
                    selectedItems.map((item) => (
                      <Box
                        key={item.path}
                        mb={1}
                        style={{
                          display: 'flex',
                          justifyContent: 'space-between',
                          alignItems: 'center',
                          gap: '6px',
                        }}
                      >
                        <div
                          style={{
                            overflow: 'hidden',
                            textOverflow: 'ellipsis',
                            whiteSpace: 'nowrap',
                          }}
                          title={item.name}
                        >
                          {item.name}
                        </div>
                        <Button
                          color="danger"
                          onClick={() => act('remove', { item: item.path })}
                        >
                          Удалить
                        </Button>
                      </Box>
                    ))
                  ) : (
                    <Box color="label" textAlign="center">
                      Пока ничего не выбрано.
                    </Box>
                  )}
                </Box>
              </Stack.Item>
            </Stack>
          </Stack.Item>

          <Stack.Item grow style={{ minWidth: 0 }}>
            <Stack vertical fill>
              <Stack.Item>
                <Tabs style={{ flexWrap: 'wrap' }}>
                  {categories.map((category, index) => (
                    <Tabs.Tab
                      key={category.name}
                      selected={index === activeTab}
                      onClick={() => setTabIndex(index)}
                      style={{
                        whiteSpace: 'nowrap',
                        backgroundColor: index === activeTab ? '#444' : '#222',
                        color: 'white',
                      }}
                    >
                      {category.name}
                    </Tabs.Tab>
                  ))}
                </Tabs>
              </Stack.Item>
              <Stack.Item
                style={{
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'center',
                  marginTop: '10px',
                }}
              >
                <Input
                  placeholder="Поиск предметов..."
                  value={searchQuery}
                  onChange={setSearchQuery}
                  width="300px"
                />
                <Button
                  onClick={handleResetClick}
                  style={{ marginTop: '10px' }}
                  color={confirmReset ? 'good' : 'danger'}
                >
                  <span style={{ color: 'white' }}>
                    {confirmReset ? 'Точно?' : 'Сбросить все'}
                  </span>
                </Button>
              </Stack.Item>
              <Stack.Item
                grow
                style={{
                  overflowY: 'auto',
                  overflowX: 'hidden',
                  minHeight: 0,
                }}
              >
                <div style={gridStyle}>
                  {visibleItems.map((item) => (
                    <ItemTile
                      key={item.path}
                      item={item}
                      selected={selectedPaths.has(item.path)}
                      onToggle={() =>
                        act(selectedPaths.has(item.path) ? 'remove' : 'add', {
                          item: item.path,
                        })
                      }
                    />
                  ))}
                </div>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
