local publicRead = include("publicRead")
local activity_9001577_Read = include("activity_9001577_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001577_ScoreItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001577/Com_9001577_ScoreItem", Com_9001577_ScoreItem)
function Com_9001577_ScoreItem:onInit()
	self:fixChildrenPos()
end
function Com_9001577_ScoreItem:onShow()
end
function Com_9001577_ScoreItem:initData(index, cfg)
	self.controllers.c1:setSelectedIndex(index % 2)
	self.fields.Text_score:setString(cfg.amount)
	dump(cfg, "Com_9001577_ScoreItem:initData(cfg)")
	local contentCfg = activity_9001577_Read.getTaskLanguageByID(cfg.languageID)
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
return Com_9001577_ScoreItem
