local resDesRead = include("resDesRead")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_monsterInfo_main = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlameWorldMap/Com_monsterInfo_main", Com_monsterInfo_main)
function Com_monsterInfo_main:onInit()
	self.occupyLv = 1
	self.maxLv = roaringFlameWarUtil.getBuildMaxLv()
	self.fields.Button_help:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onEventTouchBegin))
	self.fields.Button_help:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onEventTouchEnd))
	self.fields.Button_rate:addClickListener(handler(self, self.onClickBtnRate))
	self.fields.Com_help:setVisible(false)
	local _fields = fguiHelper.get_fields(self.fields.Com_help)
	_fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.Button_rate:fixChildrenPos()
	end
end
function Com_monsterInfo_main:onShow()
	self:initData()
end
function Com_monsterInfo_main:onClickBtnHelp(...)
	SoraDPlaySound()
	local isVisible = self.fields.Com_help:isVisible()
	self.fields.Com_help:setVisible(not isVisible)
end
function Com_monsterInfo_main:onEventTouchBegin(...)
	self.fields.Com_help:setVisible(true)
end
function Com_monsterInfo_main:onEventTouchEnd(...)
	self.fields.Com_help:setVisible(false)
end
function Com_monsterInfo_main:onClickBtnRate(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).rate = self.rate
	;(nil).callback = function(rate)
		self.rate = rate
		self = nil
		;(nil).as = rate
		self.fields.Button_rate:setString(i18n("flames_dunes_text175", nil))
	end
	uiManager:show("RoaringFlameWar_MonsterRate", nil)
end
function Com_monsterInfo_main:onItemRenderer(index, obj)
	if not SoraDFIsRA() then
		obj:fixChildrenPos()
	end
	local _fields = fguiHelper.get_fields(obj)
	if index == 0 then
		_fields.Text_lv:setString(i18n("flames_dunes_text174"))
		local resName = resDesRead.getName(gIDDef.ROARING_FLAME_WAR_HONOR_SCORE)
		_fields.Text_score:setString(resName)
		return
	end
	local level = index
	_fields.Text_lv:setString(level)
	local points = roaringFlameWarRead.getCityHonorPoints(level)
	_fields.Text_score:setString(points)
	local c1 = obj:getController("c1")
	if self.occupyLv == level then
		c1:setSelectedIndex(1)
	else
		c1:setSelectedIndex(0)
	end
end
function Com_monsterInfo_main:initData(...)
	local _fields = fguiHelper.get_fields(self.fields.Com_help)
	self.occupyLv = roaringFlameWarUtil.getOccupyBuildMaxLv()
	_ENV = nil
	;(nil).lv = self.occupyLv
	_fields.Text_des:setString(i18n("flames_dunes_text173", nil))
	_fields.List:setNumItems(self.maxLv + 1)
	_fields.List:resizeToFit(self.maxLv + 1)
	local rate = roaringFlameWarUtil.getInitMonsterRate()
	self.rate = rate
	_ENV = i18n("flames_dunes_text173", nil)
	i18n("flames_dunes_text173", nil).as = rate
	self.fields.Button_rate:setString(i18n("flames_dunes_text175", i18n("flames_dunes_text173", nil)))
	roaringFlameWarUtil.setMonsterRate(rate)
	self:updateHelpText()
end
function Com_monsterInfo_main:updateHelpText(...)
	local curScore = roaringFlameWarCtrl:getWeekMonsterScore()
	local maxScore = roaringFlameWarRead.getConstValue("FLAMES_DUNES_MONSTER_POINTS", 2000)
	local roaringFlameWarCtrl, style = "FLAMES_DUNES_MONSTER_POINTS", "FLAMES_DUNES_MONSTER_POINTS"
	if curScore >= maxScore then
		roaringFlameWarCtrl, roaringFlameWarCtrl = nil, 2000
		roaringFlameWarCtrl, (2000).num, (nil).color = nil, nil, "#ff0000"
		style, (2000).max, (nil).color = 2000, nil, "#ff0000"
	end
	roaringFlameWarCtrl = nil
	;(nil).num = curScore
	;(nil).max = maxScore
	local scoreStr = i18n_html("flames_dunes_text360", nil, style)
	local helpText = i18n("flames_dunes_text172") .. "\n" .. scoreStr
	self.fields.Text_help:setString(helpText)
	fguiHelper.setTextWidthHeight(self.fields.Text_help, cc.size(500, 60))
end
return Com_monsterInfo_main
