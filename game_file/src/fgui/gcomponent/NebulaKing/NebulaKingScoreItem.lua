local publicRead = include("publicRead")
local nebulaKingRead = include("nebulaKingRead")
local baseComponent = require("fgui.base.baseComponent")
local NebulaKingScoreItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaKing/NebulaKingScoreItem", NebulaKingScoreItem)
function NebulaKingScoreItem:onInit()
	self:fixChildrenPos()
end
function NebulaKingScoreItem:onShow()
end
function NebulaKingScoreItem:initData(index, cfg)
	self.controllers.c1:setSelectedIndex(index % 2)
	self.fields.Text_score:setString(cfg.amount)
	dump(cfg, "NebulaKingScoreItem:initData(cfg)")
	local contentCfg = nebulaKingRead.getTaskLanguageByID(cfg.languageID)
	local _ENV, args = cfg.languageID, cfg.languageID
	for i = 1, #contentCfg.type do
		local k = contentCfg.type[#contentCfg.type - (i - 1)]
		local v = cfg.condition[#cfg.condition - (i - 1)]
		if k == "item" then
			args[k] = publicRead.getName(v)
		else
			args[k] = v
		end
	end
	self.fields.Text_desc:setString(i18n(contentCfg.language, args))
end
return NebulaKingScoreItem
