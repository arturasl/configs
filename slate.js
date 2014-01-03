/*global
slate: false
*/
'use strict';

slate.bindAll({
	'l:cmd' : slate.op('focus', { direction : 'right' }),
	'h:cmd' : slate.op('focus', { direction : 'left' }),
	'k:cmd' : slate.op('focus', { direction : 'up' }),
	'j:cmd' : slate.op('focus', { direction : 'down' }),

	'l:cmd,shift' : slate.op('resize', { width : '+10' }),
	'h:cmd,shift' : slate.op('resize', { width : '+10', anchor: 'bottom-right' }),
	'k:cmd,shift' : slate.op('resize', { height : '+10', anchor: 'bottom-right'}),
	'j:cmd,shift' : slate.op('resize', { height : '+10'}),

	'q:cmd' : slate.op('hint', { characters : 'asdfghjkl' }),
	'g:cmd' : slate.op('grid', {}),
	'a:cmd' : slate.op('move', {x : 'screenOriginX', y : 'screenOriginY', width : 'screenSizeX', height : 'screenSizeY' }),
});
