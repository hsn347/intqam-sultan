local nebulaWarRead = include("nebulaWarRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_areaSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://KingStarBattle/Com_areaSingle", Com_areaSingle)
function Com_areaSingle:onInit()
	self.fields.Text_tip:setString(i18n("king_star_rank_text14"))
	self.fields.Text_tip:setVisible(false)
end
function Com_areaSingle:onShow()
end
function Com_areaSingle:initData(cfg)
	self.fields.title:setString(cfg.name)
	self.fields.Text_tip:setVisible(cfg.kingdomID == worldMapDefine.KINGSTAR_KINGDOM_ID)
	self.fields.Text_kingdoms:setVisible(cfg.kingdomID ~= worldMapDefine.KINGSTAR_KINGDOM_ID)
	if not nebulaWarRead.getServer(worldMapDefine.getKingStarActivityID(cfg.kingdomID)) then
		local _ENV, serverCfg = nebulaWarRead.getServer(worldMapDefine.getKingStarActivityID(cfg.kingdomID)), nebulaWarRead.getServer(worldMapDefine.getKingStarActivityID(cfg.kingdomID))
	end
	local _ENV, kingdomsTb = worldMapDefine.getKingStarActivityID(cfg.kingdomID)
	local isInServer = false
	local selfKid = lordInfoCtrl:getMapSourceKid()
	for k, v in ipairs(serverCfg) do
		local isSelfKid = v == selfKid
		if isSelfKid then
			isInServer = true
		end
		table.insert(kingdomsTb, fguiHelper.getColorString(isSelfKid and "#BE1E1E" or "#B4AA87", string.format("#%02d", v)))
	end
	self.fields.selfbg:setVisible(isInServer)
	self.fields.Text_kingdoms:setString(table.concat(kingdomsTb, "."))
end
return Com_areaSingle
