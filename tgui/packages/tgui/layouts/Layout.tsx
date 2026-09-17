/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { useEffect, useRef } from 'react';
import type { Box } from 'tgui-core/components';
import { addScrollableNode, removeScrollableNode } from 'tgui-core/events';
import { classes } from 'tgui-core/react';
import { computeBoxClassName, computeBoxProps } from 'tgui-core/ui';

type BoxProps = React.ComponentProps<typeof Box>;

type Props = Partial<{
  theme: string;
  fontSize: number;
  lineHeight: number;
}> &
  BoxProps;

export function Layout(props: Props) {
  const {
    className,
    theme = 'nanotrasen',
    fontSize,
    lineHeight,
    children,
    ...rest
  } = props;

  const themeClass = `theme-${theme}`;

  useEffect(() => {
    document.documentElement.className = themeClass;
  }, [themeClass]);

  // Per-player readability overrides: --font-size is what reset.scss already
  // reads, line-height has no rule anywhere so it inherits from the root.
  // Unset means removed, which leaves the theme exactly as it was.
  useEffect(() => {
    const style = document.documentElement.style;
    if (fontSize) {
      style.setProperty('--font-size', `${fontSize}px`);
    } else {
      style.removeProperty('--font-size');
    }
    if (lineHeight) {
      style.setProperty('line-height', `${lineHeight}%`);
    } else {
      style.removeProperty('line-height');
    }
  }, [fontSize, lineHeight]);

  return (
    <div className={themeClass}>
      <div
        className={classes(['Layout', className, computeBoxClassName(rest)])}
        {...computeBoxProps(rest)}
      >
        {children}
      </div>
    </div>
  );
}

type ContentProps = Partial<{
  scrollable: boolean;
}> &
  BoxProps;

function LayoutContent(props: ContentProps) {
  const { className, scrollable, children, ...rest } = props;
  const node = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const self = node.current;

    if (self && scrollable) {
      addScrollableNode(self);
    }
    return () => {
      if (self && scrollable) {
        removeScrollableNode(self);
      }
    };
  }, []);

  return (
    <div
      className={classes([
        'Layout__content',
        scrollable && 'Layout__content--scrollable',
        className,
        computeBoxClassName(rest),
      ])}
      ref={node}
      {...computeBoxProps(rest)}
    >
      {children}
    </div>
  );
}

Layout.Content = LayoutContent;
