local worldMapComTmx = class("worldMapComTmx", function(target)
	return target
end)
function worldMapComTmx:ctor()
	self.setupTileAt = false
	self._oldGetTileGIDAt = self.getTileGIDAt
	self.getTileGIDAt = self._getTileGIDAt
end
function worldMapComTmx:init(tmx, layercfg, cfg)
