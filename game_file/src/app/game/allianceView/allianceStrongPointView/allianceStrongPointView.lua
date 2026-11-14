local gametop = gModuleMgr.getObject("gametop")
local allianceStrontholdCtrl = gametop.playertop_:getModule("allianceStrontholdCtrl")
local allianceStrongPointView = class("allianceStrongPointView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceStrongPointView")
	end
	return target
end)
function allianceStrongPointView:ctor()
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.ccs_title:setTitle(i18n("alliance_stronghold_text_100"))
	self.Text_bonus = SoraDGetChildByName(self, "Text_bonus")
	self.Text_bonus:setString(i18n("alliance_stronghold_text_031"))
	self.Button_bonus = SoraDGetChildByName(self, "Button_bonus")
	self.Button_bonus:addTouchEventListener(handler(self, self.onBtnBonusClick))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_list")
	self.Node_title = SoraDGetChildByName(self, "Node_title")
	self.Node_single = SoraDGetChildByName(self, "Node_single")
	self.Text_none = SoraDGetChildByName(self, "Text_none")
	self.Text_none:setString(i18n("common_text_480"))
	allianceStrontholdCtrl:reqAllianceStrontholdList()
end
function allianceStrongPointView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_STRONTHOLD_BACK", handler(self, self.initData))
end
function allianceStrongPointView:initData()
	self.scroll:removeAllChildren()
	self.scroll:jumpToTop()
	self.strontholdList = allianceStrontholdCtrl:getHoldListByLv()
	dump(self.strontholdList, "self.strontholdList=====", 10)
	local totalH = 248
	for k, v in ipairs(self.strontholdList) do
		if next(v) then
			totalH = totalH + #v * 330
		else
			totalH = totalH + 100
		end
	end
	local newH = math.max(self.scroll:getContentSize().height, totalH)
	local width = self.scroll:getContentSize().width
	self.scroll:setInnerContainerSize(cc.size(width, newH))
	local rHeight = newH
	for k, v in ipairs(self.strontholdList) do
		local title = self.Node_title:clone()
		title:setPosition(width / 2, rHeight)
		title:addTo(self.scroll)
		allianceStrontholdCtrl = cc.size(width, newH)
		cc.size(width, newH).var = k
		SoraDGetChildByName(title, "Text_title"):setString(i18n("alliance_stronghold_text_032", cc.size(width, newH)))
		rHeight = rHeight - 62
		if next(v) then
			for i, data in ipairs(v) do
				local single = self.Node_single:clone()
				single:setPosition(width / 2, rHeight)
				single:addTo(self.scroll)
				self:setSingleInfo(single, data)
				rHeight = rHeight - 330
			end
		else
			local none = self.Text_none:clone()
			none:setPosition(width / 2, rHeight)
			none:addTo(self.scroll)
			rHeight = rHeight - 100
		end
	end
end
function allianceStrongPointView:setSingleInfo(target, data)
	local Panel_cut = SoraDGetChildByName(target, "Panel_cut")
	Panel_cut:setSwallowTouches(false)
	local Panel_cutBuild = SoraDGetChildByName(target, "Panel_cutBuild")
	Panel_cutBuild:setSwallowTouches(false)
	SoraDGetChildByName(target, "Image_pbg"):setFillType(1)
	local Image_build = SoraDGetChildByName(target, "Image_build")
	Image_build:setSpriteFrame(data.png)
	local Text_unActive = SoraDGetChildByName(target, "Text_unActive")
	Text_unActive:setString(data.isActive and i18n("alliance_stronghold_text_101") or i18n("alliance_stronghold_text_102"))
	Text_unActive:setColor(data.isActive and cc.c3b(229, 219, 199) or cc.c3b(161, 161, 161))
	SoraDGetChildByName(target, "Image_stbg1"):getVirtualRenderer():setState(data.isActive and 0 or 1)
	SoraDGetChildByName(target, "Image_stbg2"):getVirtualRenderer():setState(data.isActive and 0 or 1)
	local Text_name = SoraDGetChildByName(target, "Text_name")
	Text_name:setString(data.name)
	local Text_pos = SoraDGetChildByName(target, "Text_pos")
	if G_IS_UNITY then
		Text_pos.TitleObject.isCocos = true
	end
	_ENV = nil
	;(nil).x = data.pos.x - 1
	;(nil).y = data.pos.y - 1
	Text_pos:setString(i18n("common_text_2155", nil))
	Text_pos:setTouchEnabled(true)
	Text_pos:setTouchScaleChangeEnabled(true)
	Text_pos:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			SoraDPlaySound()
			_ENV = nil
			;(nil).x = data.pos.x - 1
			;(nil).y = data.pos.y - 1
			SoraDGotoWorldMapPoint(nil, true)
			SoraDRemoveAllPanelFromManager()
		end
	end)
	local Node_attr = SoraDGetChildByName(target, "Node_attr")
	local Node_bonus = SoraDGetChildByName(target, "Node_bonus")
	Node_bonus:setVisible(false)
	for k, v in ipairs(data.bonus) do
		local single
		if k == 1 then
			single = Node_bonus
		else
			single = Node_bonus:clone()
			single:addTo(Node_attr)
		end
		single:setVisible(true)
		single:setPosition(0, -(k - 1) * 40)
		local Text_bonusStr = SoraDGetChildByName(single, "Text_bonusStr")
		local Text_bonusVal = SoraDGetChildByName(single, "Text_bonusVal")
		Text_bonusStr:setString(v.des)
		Text_bonusVal:setString(v.val)
		Text_bonusStr:setColor(data.isActive and cc.c3b(255, 250, 211) or cc.c3b(178, 178, 178))
		Text_bonusVal:setColor(data.isActive and cc.c3b(255, 250, 211) or cc.c3b(178, 178, 178))
	end
	local Node_status = SoraDGetChildByName(target, "Node_status")
	local icon_status = SoraDGetChildByName(target, "icon_status")
	icon_status:setSpriteFrame(data.status == gKingdomWarStatusType.rule and "icon_ldjd_baohuzhong_02.png" or "icon_ldjd_kegongji_02.png")
	local Image_color = SoraDGetChildByName(target, "Image_color")
	local Text_time = SoraDGetChildByName(target, "Text_time")
	Text_time = SoraDCreateTimerLabel(self, Text_time)
	if data.status == gKingdomWarStatusType.rule then
		Text_time:setTimeLast(function(time)
			_ENV = nil
			;(nil).var = time
			return i18n("alliance_stronghold_text_040", nil)
		end)
		Text_time:setColor(cc.c3b(30, 200, 220))
		Image_color:setColor(cc.c3b(30, 200, 220))
	end
	local leftTime = data.statusEndTime - serviceFunctions.systemTime()
	print("leftTime======", leftTime, data.pos.x, data.pos.y)
	if 0 < leftTime then
		Text_time:beginTime(leftTime)
		SoraDToCenter(Node_status)
	end
end
function allianceStrongPointView:onBtnBonusClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("allianceStrongPointBonusView"):show()
	end
end
return allianceStrongPointView
