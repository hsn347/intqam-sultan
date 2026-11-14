local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local lordLocalData = include("lordLocalData")
local lordSpineDef = include("lordSpineDef")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameWar_MVPPanel = class("RoaringFlameWar_MVPPanel", baseFguiPanel)
local string_fnt = string.formatnumberthousands
function RoaringFlameWar_MVPPanel:ctor(...)
	RoaringFlameWar_MVPPanel.super.ctor(self, ...)
	print("RoaringFlameWar_MVPPanel:ctor", self.viewName)
end
function RoaringFlameWar_MVPPanel:onInit()
	print("=======RoaringFlameWar_MVPPanel:onInit")
	self.fields.Text_tip:setString(i18n("common_text_3701"))
end
function RoaringFlameWar_MVPPanel:onShow()
	print("=======RoaringFlameWar_MVPPanel:onShow")
	local data = self.param and self.param.resultData
	self:initComPlayer(data)
	self:initComMyInfo(data)
end
function RoaringFlameWar_MVPPanel:initCheatData(...)
	_UPVALUE0_ = nil
	_UPVALUE0_, (nil).campScore = nil, 10
	;(nil).attackCount = 100
	;(nil).avatar = ""
	;(nil).fromKid = 1
	;(nil).iconID = 1405
	;(nil).killScore = 1000
	;(nil).name = "mly"
	_UPVALUE0_, (nil).maxPlayerInfo, (nil).uid = nil, nil, 1
	;(nil).attackCount = 100
	;(nil).attackCountWin = 0
	;(nil).avatar = ""
	;(nil).fromKid = 1
	;(nil).iconID = 1405
	;(nil).killScore = 1000
	;(nil).name = "mly"
	_UPVALUE0_, (nil).selfPlayerInfo, (nil).uid = nil, nil, 1
	local resultData
	self.param, (nil).resultData = nil, resultData
end
function RoaringFlameWar_MVPPanel:initComPlayer(data)
	self.fields.Com_player:setVisible(true)
	local _fields = fguiHelper.get_fields(self.fields.Com_player)
	_fields.mv_guangdian:setAllFrameName("9001674_guangdian_%02d.png", 1)
	local c1 = self.fields.Com_player:getController("c1")
	local maxPlayerInfo = data.maxPlayerInfo
	if not maxPlayerInfo then
		c1:setSelectedIndex(1)
		local info = lordSpineDef.getLordSpineInfo(1405)
		_fields.Spine_lord:setEffectPath(info.json)
		_fields.Spine_lord:getSpine():setColor(cc.c3b(125, 125, 125))
		_fields.Text_noData:setString(i18n("guide_text_168"))
		return
	end
	c1:setSelectedIndex(0)
	local info = lordSpineDef.getLordSpineInfo(maxPlayerInfo.iconID)
	_fields.Spine_lord:setEffectPath(info.json)
	_fields.Spine_lord:getSpine():setColor(cc.c3b(255, 255, 255))
	_fields.Text_name:setString(maxPlayerInfo.name)
	local camp = roaringFlameWarCtrl:getCampWithKid(maxPlayerInfo.kid)
	local campName = roaringFlameWarRead.getCampName(camp)
	_ENV = cc.c3b(255, 255, 255)
	cc.c3b(255, 255, 255).camp = campName
	_fields.Text_camp:setString(i18n("flames_dunes_text228", cc.c3b(255, 255, 255)))
	local campScore = maxPlayerInfo.campScore or 0
	_ENV = i18n("flames_dunes_text228", cc.c3b(255, 255, 255))
	i18n("flames_dunes_text228", cc.c3b(255, 255, 255)).num = string_fnt(campScore)
	_fields.Text_value1:setString(i18n("flames_dunes_text188", i18n("flames_dunes_text228", cc.c3b(255, 255, 255))))
	_ENV = i18n("flames_dunes_text188", i18n("flames_dunes_text228", cc.c3b(255, 255, 255)))
	i18n("flames_dunes_text188", i18n("flames_dunes_text228", cc.c3b(255, 255, 255))).num = maxPlayerInfo.attackCount or 0
	_fields.Text_value2:setString(i18n("flames_dunes_text189", i18n("flames_dunes_text188", i18n("flames_dunes_text228", cc.c3b(255, 255, 255)))))
	local killScore = math.floor(maxPlayerInfo.killScore or 0)
	_ENV = i18n("flames_dunes_text189", i18n("flames_dunes_text188", i18n("flames_dunes_text228", cc.c3b(255, 255, 255))))
	i18n("flames_dunes_text189", i18n("flames_dunes_text188", i18n("flames_dunes_text228", cc.c3b(255, 255, 255)))).num = string_fnt(killScore)
	_fields.Text_value3:setString(i18n("flames_dunes_text190", i18n("flames_dunes_text189", i18n("flames_dunes_text188", i18n("flames_dunes_text228", cc.c3b(255, 255, 255))))))
end
function RoaringFlameWar_MVPPanel:initComMyInfo(data)
	if not SoraDFIsRA() then
		self.fields.Com_myInfo:fixChildrenPos()
	end
	local selfPlayerInfo = data.selfPlayerInfo
	local _fields = fguiHelper.get_fields(self.fields.Com_myInfo)
	local bust = lordLocalData.getPortrait(selfPlayerInfo.iconID)
	_fields.Load_player:setURL(bust)
	_fields.Text_title:setString(i18n("flames_dunes_text227"))
	_ENV = _fields.Text_title.setString
	local _fields.Text_title.setString.color, style = "#F0E6D2", _fields.Text_title.setString
	local attackCount = selfPlayerInfo.attackCount or 0
	local numStr = SoraDWrapHtmlTagByStyle(attackCount, style)
	_ENV = i18n("flames_dunes_text227")
	i18n("flames_dunes_text227").num = numStr
	_fields.Text_value1:setString(i18n("flames_dunes_text191", i18n("flames_dunes_text227")))
	_ENV = i18n("flames_dunes_text191", i18n("flames_dunes_text227"))
	i18n("flames_dunes_text191", i18n("flames_dunes_text227")).num = numStr
	_fields.Text_value2:setString(i18n("flames_dunes_text189", i18n("flames_dunes_text191", i18n("flames_dunes_text227"))))
	local attackCountWin = selfPlayerInfo.attackCountWin or 0
	local numStr = SoraDWrapHtmlTagByStyle(attackCountWin, style)
	_ENV = i18n("flames_dunes_text189", i18n("flames_dunes_text191", i18n("flames_dunes_text227")))
	i18n("flames_dunes_text189", i18n("flames_dunes_text191", i18n("flames_dunes_text227"))).num = numStr
	_fields.Text_value3:setString(i18n("flames_dunes_text192", i18n("flames_dunes_text189", i18n("flames_dunes_text191", i18n("flames_dunes_text227")))))
	local killScore = math.floor(selfPlayerInfo.killScore or 0)
	local numStr = SoraDWrapHtmlTagByStyle(string_fnt(killScore), style)
	_ENV = i18n("flames_dunes_text192", i18n("flames_dunes_text189", i18n("flames_dunes_text191", i18n("flames_dunes_text227"))))
	i18n("flames_dunes_text192", i18n("flames_dunes_text189", i18n("flames_dunes_text191", i18n("flames_dunes_text227")))).num = numStr
	_fields.Text_value4:setString(i18n("flames_dunes_text190", i18n("flames_dunes_text192", i18n("flames_dunes_text189", i18n("flames_dunes_text191", i18n("flames_dunes_text227"))))))
end
return RoaringFlameWar_MVPPanel
