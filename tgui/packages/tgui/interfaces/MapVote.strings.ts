import { useLang } from '../i18n';

const RU: Record<string, string> = {
  'Map Vote': 'Голосование за карту',
  'Maps': 'Карты',
  'Old Maps - Beta test': 'Старые карты — бета-тест',
  'Start vote': 'Начать голосование',
  'Cancel the running vote': 'Отменить текущее голосование',
  'Vote': 'Голос',
  'Counting votes': 'Подсчёт голосов',
  'Map pool — no vote running': 'Пул карт — голосование не идёт',
  'Now': 'Сейчас',
  'Next': 'Далее',
  'unknown': 'неизвестно',
  'Your vote is in.': 'Ваш голос учтён.',
  'Player map voting is currently disabled by the server.':
    'Голосование за карты сейчас отключено сервером.',
  'votable': 'доступна',
  'unavailable': 'недоступна',
  '(current)': '(текущая)',
  '(next)': '(следующая)',
  'players': 'игроков',
  'up to': 'до',
  'left': 'осталось',
};

export function useMapVoteTp() {
  const lang = useLang();
  return <T,>(value: T): T => {
    if (typeof value !== 'string' || lang !== 'ru') {
      return value;
    }
    return (RU[value] ?? value) as T;
  };
}
