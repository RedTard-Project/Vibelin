import {
  Box,
  Button,
  Icon,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';
import { useMapVoteTp } from './MapVote.strings';

type MapEntry = {
  index: number;
  name: string;
  category: string;
  blurb: string;
  votes: number;
  votable: boolean;
  min_players: number;
  max_players: number;
  current: boolean;
  next: boolean;
};

type MapVoteData = {
  active: boolean;
  maps: MapEntry[];
  categories: string[];
  time_remaining: number;
  has_voted: boolean;
  is_admin: boolean;
  voting_allowed: boolean;
  other_vote_running: boolean;
  other_vote_mode: string;
  current_map: string;
  next_map: string;
};

function playerRange(entry: MapEntry, tp: <T>(v: T) => T): string {
  const min = Number(entry.min_players) || 0;
  const max = Number(entry.max_players) || 0;
  if (min > 0 && max > 0) {
    return `${min}-${max} ${tp('players')}`;
  }
  if (min > 0) {
    return `${min}+ ${tp('players')}`;
  }
  if (max > 0) {
    return `${tp('up to')} ${max} ${tp('players')}`;
  }
  return '';
}

export function MapVote() {
  const { act, data } = useBackend<MapVoteData>();
  const tp = useMapVoteTp();
  const {
    active,
    maps = [],
    categories = [],
    time_remaining,
    has_voted,
    is_admin,
    voting_allowed,
    other_vote_running,
    other_vote_mode,
    current_map,
    next_map,
  } = data;

  const totalVotes = maps.reduce((sum, entry) => sum + (entry.votes || 0), 0);
  const leader = active
    ? maps.reduce<MapEntry | null>(
        (best, entry) =>
          !best || (entry.votes || 0) > (best.votes || 0) ? entry : best,
        null,
      )
    : null;

  return (
    <Window title={tp('Map Vote')} width={420} height={560}>
      <Window.Content scrollable>
        <Section>
          <Stack align="center">
            <Stack.Item grow>
              {active ? (
                <Box bold>
                  <Icon name="hourglass-half" mr={1} />
                  {time_remaining > 0
                    ? `${time_remaining}s ${tp('left')}`
                    : tp('Counting votes')}
                </Box>
              ) : (
                <Box color="label">{tp('Map pool — no vote running')}</Box>
              )}
              <Box color="label" fontSize="11px">
                {tp('Now')}: {current_map || tp('unknown')}
                {next_map ? ` → ${tp('Next')}: ${next_map}` : ''}
              </Box>
            </Stack.Item>
            <Stack.Item>
              {active ? (
                is_admin ? (
                  <Button
                    color="bad"
                    icon="ban"
                    onClick={() => act('cancel')}
                    tooltip={tp('Cancel the running vote')}
                  />
                ) : null
              ) : (
                <Button
                  icon="check-to-slot"
                  disabled={
                    other_vote_running || (!voting_allowed && !is_admin)
                  }
                  onClick={() => act('start')}
                >
                  {tp('Start vote')}
                </Button>
              )}
            </Stack.Item>
          </Stack>
        </Section>

        {other_vote_running ? (
          <NoticeBox>
            A {other_vote_mode} vote is already running. Map voting is
            unavailable until it ends.
          </NoticeBox>
        ) : null}

        {active && has_voted ? (
          <NoticeBox success>{tp('Your vote is in.')}</NoticeBox>
        ) : null}

        {!active && !voting_allowed && !is_admin ? (
          <NoticeBox info>
            {tp('Player map voting is currently disabled by the server.')}
          </NoticeBox>
        ) : null}

        {categories.map((category) => {
          const entries = maps.filter((entry) => entry.category === category);
          if (!entries.length) {
            return null;
          }
          return (
            <Section key={category} title={tp(category)}>
              <Stack vertical>
                {entries.map((entry) => {
                  const share =
                    active && totalVotes > 0
                      ? Math.round(((entry.votes || 0) / totalVotes) * 100)
                      : 0;
                  const range = playerRange(entry, tp);
                  return (
                    <Stack.Item key={entry.name}>
                      <Stack align="center">
                        <Stack.Item grow>
                          <Box bold={entry.current}>
                            {entry.name}
                            {entry.current ? (
                              <Box as="span" color="label" ml={1}>
                                {tp('(current)')}
                              </Box>
                            ) : null}
                            {entry.next ? (
                              <Box as="span" color="good" ml={1}>
                                {tp('(next)')}
                              </Box>
                            ) : null}
                          </Box>
                          {entry.blurb ? (
                            <Box color="label" fontSize="11px">
                              {entry.blurb}
                            </Box>
                          ) : null}
                          {range ? (
                            <Box color="label" fontSize="11px">
                              {range}
                            </Box>
                          ) : null}
                        </Stack.Item>
                        {active ? (
                          <>
                            <Stack.Item width="52px" textAlign="right">
                              <Box color={leader === entry ? 'good' : 'label'}>
                                {entry.votes || 0}
                                {totalVotes > 0 ? ` (${share}%)` : ''}
                              </Box>
                            </Stack.Item>
                            <Stack.Item>
                              <Button
                                icon="check"
                                disabled={has_voted}
                                onClick={() =>
                                  act('vote', { index: entry.index })
                                }
                              >
                                {tp('Vote')}
                              </Button>
                            </Stack.Item>
                          </>
                        ) : (
                          <Stack.Item>
                            <Box color={entry.votable ? 'good' : 'label'}>
                              {tp(entry.votable ? 'votable' : 'unavailable')}
                            </Box>
                          </Stack.Item>
                        )}
                      </Stack>
                    </Stack.Item>
                  );
                })}
              </Stack>
            </Section>
          );
        })}
      </Window.Content>
    </Window>
  );
}
