import { useEffect, useRef } from 'react';

type MapViewParams = {
  id: string;
  type?: string;
  zoom?: number;
  'zoom-mode'?: string;
  'background-color'?: string;
  [key: string]: string | number | undefined;
};

type ByondMapViewProps = {
  params: MapViewParams;
  /** Extra values that must force a re-place even if `params` is unchanged. */
  deps?: ReadonlyArray<unknown>;
  className?: string;
  style?: React.CSSProperties;
};

type Rect = { x: number; y: number; w: number; h: number };

const SETTLE_TICKS = 2;
const RETRY_DELAYS = [0, 50, 150, 400, 900, 1800, 3200];

function readRect(element: HTMLElement | null): Rect | null {
  if (!element) {
    return null;
  }
  const dpr = window.devicePixelRatio || 1;
  const box = element.getBoundingClientRect();
  const w = Math.floor((box.right - box.left) * dpr);
  const h = Math.floor((box.bottom - box.top) * dpr);
  if (w <= 0 || h <= 0) {
    return null;
  }
  return {
    x: Math.floor(box.left * dpr),
    y: Math.floor(box.top * dpr),
    w,
    h,
  };
}

function sameRect(a: Rect | null, b: Rect | null): boolean {
  if (!a || !b) {
    return false;
  }
  return a.x === b.x && a.y === b.y && a.w === b.w && a.h === b.h;
}

/**
 * A BYOND child control (usually a map) pinned to the box this component
 * renders.
 *
 * Unlike `tgui-core`'s `ByondUi` it re-places the control whenever the box
 * moves, resizes or its params change, and it keeps the control hidden until
 * the box has reported the same real rectangle twice. A control placed from a
 * rectangle measured before the window finished laying out is what paints a
 * stray black rectangle across the interface.
 */
export function ByondMapView(props: ByondMapViewProps) {
  const { params, deps = [], className, style } = props;
  const boxRef = useRef<HTMLDivElement>(null);
  const placedRect = useRef<Rect | null>(null);
  const placedParams = useRef<string>('');
  const settled = useRef(0);
  const visible = useRef(false);
  const alive = useRef(false);
  const timers = useRef<ReturnType<typeof setTimeout>[]>([]);
  const frame = useRef<number | null>(null);
  const placeRef = useRef<() => void>(() => {});
  const scheduleRef = useRef<() => void>(() => {});

  const controlId = params?.id;
  const paramKey = JSON.stringify(params ?? {});
  const depKey = JSON.stringify(deps);

  placeRef.current = () => {
    if (!alive.current || !controlId) {
      return;
    }
    const rect = readRect(boxRef.current);
    if (!rect) {
      settled.current = 0;
      if (visible.current) {
        visible.current = false;
        Byond.winset(controlId, { 'is-visible': false });
      }
      return;
    }

    const paramsChanged = placedParams.current !== paramKey;
    if (sameRect(placedRect.current, rect) && !paramsChanged) {
      if (settled.current < SETTLE_TICKS) {
        settled.current++;
      }
      if (settled.current >= SETTLE_TICKS && !visible.current) {
        visible.current = true;
        Byond.winset(controlId, { 'is-visible': true });
      }
      return;
    }

    settled.current = 0;
    placedRect.current = rect;
    placedParams.current = paramKey;
    Byond.winset(controlId, {
      parent: Byond.windowId,
      ...params,
      'is-visible': visible.current,
      pos: `${rect.x},${rect.y}`,
      size: `${rect.w}x${rect.h}`,
    });
    scheduleRef.current();
  };

  scheduleRef.current = () => {
    if (frame.current !== null) {
      cancelAnimationFrame(frame.current);
    }
    frame.current = requestAnimationFrame(() => {
      frame.current = null;
      placeRef.current();
    });
  };

  useEffect(() => {
    alive.current = true;
    const schedule = () => scheduleRef.current();
    const retry = () => {
      timers.current.forEach(clearTimeout);
      timers.current = RETRY_DELAYS.map((delay) =>
        setTimeout(() => placeRef.current(), delay),
      );
    };

    retry();

    let observer: ResizeObserver | undefined;
    if (typeof ResizeObserver !== 'undefined') {
      observer = new ResizeObserver(schedule);
      if (boxRef.current) {
        observer.observe(boxRef.current);
      }
      if (document.body) {
        observer.observe(document.body);
      }
    }
    window.addEventListener('resize', schedule);
    window.addEventListener('scroll', schedule, true);
    window.addEventListener('load', retry);
    document.addEventListener('visibilitychange', retry);

    return () => {
      alive.current = false;
      window.removeEventListener('resize', schedule);
      window.removeEventListener('scroll', schedule, true);
      window.removeEventListener('load', retry);
      document.removeEventListener('visibilitychange', retry);
      observer?.disconnect();
      timers.current.forEach(clearTimeout);
      timers.current = [];
      if (frame.current !== null) {
        cancelAnimationFrame(frame.current);
        frame.current = null;
      }
      if (controlId) {
        Byond.winset(controlId, { 'is-visible': false, parent: '' });
      }
      visible.current = false;
      placedRect.current = null;
      placedParams.current = '';
      settled.current = 0;
    };
  }, [controlId]);

  useEffect(() => {
    placeRef.current();
  }, [paramKey, depKey]);

  return <div ref={boxRef} className={className} style={style} />;
}
