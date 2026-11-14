local nebulaWarRead = include("nebulaWarRead")
local nebulaWarUtil = include("nebulaWarUtil")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_group = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://NebulaWarNew/Com_group", Com_group)
fgui.register_extension("ui://NebulaWarNew/Com_group2", Com_group)
fgui.register_extension("ui://NebulaWarNew/Com_group3", Com_group)
function Com_group:onInit()
	self:addClickListener(function()
		SoraDPlaySound()
		_ENV = nil
		;(nil).groupId = self.groupId
		uiManager:show("NebulaWarCampKingdom", nil)
	end)
end
function Com_group:onShow()
end
function Com_group:initData(groupId, campScoreInfo)
	self.groupId = groupId
	local abbr = nebulaWarRead.getWarGroupAbbr(groupId)
	local name = nebulaWarRead.getWarGroupName(groupId)
	nebulaWarRead = nil
	;(nil).abbr = abbr
	;(nil).name = name
	self.fields.title:setString(i18n("common_text_186", nil))
	if nebulaWarUtil.checkShowEnterBtn() then
		self:setIcon(nebulaWarRead.getWarGroupImg(groupId))
		local camp = nebulaWarUtil.getCampByGroupId(groupId)
		if not campScoreInfo[camp] then
			nebulaWarRead = campScoreInfo[camp]
		end
		local score = nebulaActivityCtrl:getPlayerScore(campScoreInfo[camp])
		nebulaWarRead = nebulaWarRead.getWarGroupImg(groupId)
		nebulaWarRead.getWarGroupImg(groupId).point = string.formatnumberthousands(score)
		self.fields.Text_score:setString(i18n("common_text_3347", nebulaWarRead.getWarGroupImg(groupId)))
	elseif nebulaWarUtil.checkIsInWarReady() then
		self:setIcon(nebulaWarRead.getWarGroupImg(groupId))
		nebulaWarRead = nebulaWarRead.getWarGroupImg(groupId)
		nebulaWarRead.getWarGroupImg(groupId).point = 0
		self.fields.Text_score:setString(i18n("common_text_3347", nebulaWarRead.getWarGroupImg(groupId)))
	else
		self:setIcon(nebulaWarRead.getWarGroupIcon(groupId))
		local score = nebulaActivityCtrl:getSeasonScore(groupId)
		nebulaWarRead = nebulaWarRead.getWarGroupIcon(groupId)
		nebulaWarRead.getWarGroupIcon(groupId).num = string.formatnumberthousands(score)
		self.fields.Text_score:setString(i18n("nebula_war_text_0504", nebulaWarRead.getWarGroupIcon(groupId)))
	end
end
return Com_group
