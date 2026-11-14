local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonUITestPanel = class("CommonUITestPanel", baseFguiPanel)
function CommonUITestPanel:ctor(...)
	CommonUITestPanel.super.ctor(self, ...)
	print("CommonUITestPanel:ctor", self.viewName)
end
function CommonUITestPanel:onInit()
	print("=======CommonUITestPanel:onInit")
	self.tag = 1
	self.fields.Com_title:initData(i18n("CommonUI测试"), handler(self, self.onClickClose))
end
function CommonUITestPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "pyramidBattleView"
	end
	return self._packageList
end
function CommonUITestPanel:onShow()
	print("=======CommonUITestPanel:onShow")
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = "进度条"
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = "按钮"
	_ENV, self.tag[2], (nil).tag = nil, nil, 2
	;(nil).title = "下拉框"
	_ENV, self.tag[3], (nil).tag = nil, nil, 3
	;(nil).title = "装备"
	_ENV, self.tag[4], (nil).tag = nil, nil, 4
	;(nil).title = "拥有道具"
	_ENV, self.tag[5], (nil).tag = nil, nil, 5
	;(nil).title = "领主头像"
	_ENV, self.tag[6], (nil).tag = nil, nil, 6
	;(nil).title = "英雄"
	_ENV, self.tag[7], (nil).tag = nil, nil, 7
	;(nil).title = "道具"
	_ENV, self.tag[8], (nil).tag = nil, nil, 8
	;(nil).title = "滑动条"
	_ENV, self.tag[9], (nil).tag = nil, nil, 9
	;(nil).title = "时间"
	;(nil).tabsetArray, self.tag[10], (nil).tag = self.tag, nil, 10
	;(nil).callback = handler(self, self.onClickTabBtn)
	self.fields.com_Tab:initView(nil)
end
function CommonUITestPanel:onClickTabBtn(tag)
	self.tag = tag
	self.controllers.c_type:setSelectedIndex(self.tag - 1)
	self:initView()
end
function CommonUITestPanel:onTabClick(tag)
	self.testTag = tag
	print("self.testTag=====", self.testTag)
end
function CommonUITestPanel:initView()
	if self.tag == 1 then
		for i = 1, 4 do
			self.fields["bar" .. i]:setMax(100)
			self.fields["bar" .. i]:setTitleType(i - 1)
		end
		self.fields.bar1:setValue(20)
		self.fields.bar2:setTime(60, 100)
		self.fields.bar3:tweenValue(60, 0.5)
		self.fields.bar4:setValue(80)
		self.fields.bar4:hideTitle()
		self.fields.Label_title:setString("醉里挑灯看剑，梦回吹角连营，八百里分麾下炙，五十弦翻塞外声，沙场秋点兵", 400)
		_UPVALUE3_ = self.fields.Label_title.setString
		self.fields.Label_title.setString[1] = 40
		self.fields.Label_title.setString[2] = 30
		local self.fields.Label_title.setString[3], gapTest = 30, self.fields.Label_title.setString
		for i = 1, 3 do
			_ENV = i
			i.stageMax = 1 + i
			i.gap = gapTest[i]
			self.fields["Com_boxList_" .. i]:initData(i)
		end
	elseif self.tag == 2 then
		self.fields.btn_cost1:setString("抽奖10次")
		self.fields.btn_cost1:setCost(844001, 10)
		self.fields.btn_cost1:setBtnColorIndex(gBtnColorDef.BLUE)
		self.fields.btn_cost2:setString("抽奖1次")
		self.fields.btn_cost2:setCost(1001, 1)
		self.fields.btn_cost2:setReddot(true, -1)
		self.fields.btn_normal1:setString("确定")
		self.fields.btn_normal2:setString("领取")
		self.fields.btn_normal2:setReddot(true, -1)
		self.fields.btn_price1:initData(844001, 888, 9999)
		self.fields.btn_price2:initData(844001, 888)
		self.fields.btn_style1:setString("记录")
		self.fields.btn_style2:setString("奖励")
		self.fields.btn_style2:setReddot(true, 6)
		self.fields.btn_small:setString("前往")
		self.fields.btn_small:setBtnColorIndex(gBtnColorDef.RED)
		self.fields.btn_recharge:initData("$9.99", "$99.99")
		self.fields.btn_goldTop:setString(SoraDGetGold())
	elseif self.tag == 3 then
		_UPVALUE3_, self.curSortType = self.tag, 1
		_UPVALUE3_, self.tag[1] = "品质", "品质"
		_UPVALUE3_, self.tag[2] = "品质", "等级"
		local _UPVALUE3_, self.tag[3], items = "品质", "稀有度", self.tag
		;("品质")[1] = 1
		;("品质")[2] = 2
		local ("品质")[3], values = 3, "品质"
		_ENV = SoraDGetGold()
		SoraDGetGold().items = items
		SoraDGetGold().values = values
		SoraDGetGold().changedCallback = handler(self, self.onComboBoxClick)
		self:setComboBox(self.fields.comboBox, SoraDGetGold())
		local dropdown = self.fields.comboBox:getDropdown()
		self.comboBoxList = dropdown:getChildByName("list")
		self.fields.comboBox:addClickListener(function()
			SoraDPlaySound()
			self.comboBoxList:setSelectedIndex(self.curSortType - 1)
		end)
		self.fields.comboBox:fixChildrenPos()
		self.testTag = 1
		self.fields.Com_titleTest:initData("测试", handler(self, self.onClickClose))
		_ENV = "测试"
		_ENV, _ENV, ("测试").defaultClick = handler(self, self.onClickClose)
		handler(self, self.onClickClose).title = i18n("skin_text_15")
		_ENV, self.testTag[1], handler(self, self.onClickClose).tag = handler(self, self.onClickClose)
		handler(self, self.onClickClose).title = i18n("skin_text_16")
		;("测试").tabsetArray, self.testTag[2], handler(self, self.onClickClose).tag = self.testTag, handler(self, self.onClickClose)
		;("测试").callback = handler(self, self.onTabClick)
		self.fields.Com_titleTest:initTab("测试")
	elseif self.tag == 4 then
		local equipmentMgr = include("equipmentMgr")
		self.tableEquipData = equipmentMgr.getEquipmentArrayWithFiler()
		self.fields.Com_equip:initData(self.tableEquipData[1])
		self.tableEquip2Data, _ENV, self.tableEquip1Data, _ENV = self.fields.Com_equip.initData, self.fields.Com_equip.initData, self.fields.Com_equip.initData, self.fields.Com_equip.initData
		for i = 1, 3 do
			table.insert(self.tableEquip1Data, self.tableEquipData[i])
			table.insert(self.tableEquip2Data, self.tableEquipData[i])
		end
		self.fields.List_equip1:setItemRenderer(handler(self, self.onEquip1Renderer))
		self.fields.List_equip1:setNumItems(#self.tableEquip1Data)
		self.fields.List_equip2:setItemRenderer(handler(self, self.onEquip2Renderer))
		self.fields.List_equip2:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseItem))
		self.fields.List_equip2:setNumItems(#self.tableEquip2Data)
	elseif self.tag == 5 then
		self.fields.Com_have:initData(844001)
		self.fields.Com_have2:initData(228601)
		self.fields.Com_have2:hideBtnAdd()
		local curTime = serviceFunctions.systemTime()
		_ENV = self.fields.Com_have2
		_ENV, self.fields.Com_have2.toTeamId = 228601, 2
		;(228601).x = 112
		self.fields.Com_have2.from, (228601).y = 228601, 35
		self.fields.Com_have2.statusStartTime = curTime
		local self.fields.Com_have2.statusEndTime, queueData = curTime + 100, self.fields.Com_have2
		self.fields.Com_battle:initData(queueData)
	elseif self.tag == 6 then
		local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
		local dressCtrl = SoraDGetCtrl("dressCtrl")
		self.fields.Com_head:setSelfHead()
		self.fields.Com_headFrame:setSelfHead(true)
	elseif self.tag == 7 then
		self.fields.Com_hero:initData(1747, 174702)
		_UPVALUE7_ = self.fields.Com_hero.initData
		self.heroList, self.fields.Com_hero.initData[1] = self.fields.Com_hero.initData, 1700
		self.heroList, self.fields.Com_hero.initData[2] = self.fields.Com_hero.initData, 1701
		self.heroList, self.fields.Com_hero.initData[3] = self.fields.Com_hero.initData, 1723
		self.heroList, self.fields.Com_hero.initData[4] = self.fields.Com_hero.initData, 1734
		self.heroList, self.fields.Com_hero.initData[5] = self.fields.Com_hero.initData, 1741
		self.heroList, self.fields.Com_hero.initData[6] = self.fields.Com_hero.initData, 1742
		self.heroList, self.fields.Com_hero.initData[7] = self.fields.Com_hero.initData, 1747
		self.fields.List_hero:setItemRenderer(handler(self, self.onHeroRenderer))
		self.fields.List_hero:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseHero))
		self.fields.List_hero:setNumItems(#self.heroList)
	elseif self.tag == 8 then
		self.fields.Com_item:initData(844001, 99)
		_ENV, _ENV = self.fields.Com_item, self.fields.Com_item.initData
		self.fields.Com_item.id = 844001
		_ENV, self.fields.Com_item.initData[1], self.fields.Com_item.count = self.fields.Com_item, self.fields.Com_item, 1
		self.fields.Com_item.id = 12010101
		_ENV, self.fields.Com_item.initData[2], self.fields.Com_item.count = self.fields.Com_item, self.fields.Com_item, 2
		self.fields.Com_item.id = 5022004
		_ENV, self.fields.Com_item.initData[3], self.fields.Com_item.count = self.fields.Com_item, self.fields.Com_item, 3
		self.fields.Com_item.id = 7020402
		_ENV, self.fields.Com_item.initData[4], self.fields.Com_item.count = self.fields.Com_item, self.fields.Com_item, 4
		self.fields.Com_item.id = 218601
		self.itemArray, self.fields.Com_item.initData[5], self.fields.Com_item.count = self.fields.Com_item.initData, self.fields.Com_item, 5
		self.fields.List_item:setItemRenderer(handler(self, self.onItemRenderer))
		self.fields.List_item:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChoose))
		self.fields.List_item:setNumItems(#self.itemArray)
	elseif self.tag == 9 then
		self.fields.Com_slider1:setSliderCallBack(handler(self, self.onSliderBack))
		_ENV = handler(self, self.onSliderBack)
		handler(self, self.onSliderBack).maxValue = 999
		handler(self, self.onSliderBack).minValue = 1
		handler(self, self.onSliderBack).curValue = 1
		self.fields.Com_slider1:initData(handler(self, self.onSliderBack))
		_ENV = handler(self, self.onSliderBack)
		handler(self, self.onSliderBack).maxValue = 888
		handler(self, self.onSliderBack).minValue = 0
		handler(self, self.onSliderBack).curValue = 0
		handler(self, self.onSliderBack).allowZero = true
		self.fields.Com_slider2:initData(handler(self, self.onSliderBack))
	elseif self.tag == 10 then
		local activityID = 9001655
		self.fields.Label_timer:beginTime(3605)
		self.fields.Label_timer2:initCommonActivityTime(activityID)
		self.fields.Label_timer3:setTimeLast(function(time)
			return fguiHelper.getColorString("#FFC864", i18n("common_text_2669")) .. fguiHelper.getColorString("#FFFFFF", time)
		end)
		self.fields.Label_timer3:beginTime(3605)
		self.fields.Label_timer4:initActivityTimeStyle(activityID, "距离活动结束:%{time}", "#FFC800")
		self.fields.Label_timer5:beginTime(3605)
	end
end
function CommonUITestPanel:onHeroRenderer(index, obj)
	obj:initData(self.heroList[index + 1])
end
function CommonUITestPanel:onChooseHero()
	SoraDPlaySound()
	self.heroIndex = self.fields.List_hero:getSelectedIndex() + 1
	print("self.heroIndex===", self.heroIndex)
end
function CommonUITestPanel:onSliderBack(value)
	print("onSliderBack===", value)
end
function CommonUITestPanel:onItemRenderer(index, obj)
	obj:initData(self.itemArray[index + 1].id, self.itemArray[index + 1].count)
	if 1 <= index and index <= 3 then
		obj:setEffect(index)
	end
end
function CommonUITestPanel:onChoose()
	SoraDPlaySound()
	self.selIndex = self.fields.List_item:getSelectedIndex() + 1
	print("self.selIndex===", self.selIndex)
end
function CommonUITestPanel:onEquip1Renderer(index, obj)
	obj:initData(self.tableEquip1Data[index + 1])
end
function CommonUITestPanel:onEquip2Renderer(index, obj)
	obj:initData(self.tableEquip2Data[index + 1])
end
function CommonUITestPanel:onChooseItem()
	SoraDPlaySound()
	self.selIndex = self.fields.List_equip2:getSelectedIndex() + 1
	print("self.selIndex===", self.selIndex)
end
function CommonUITestPanel:onComboBoxClick()
	SoraDPlaySound()
	self.curSortType = tonumber(self.fields.comboBox:getValue())
	print("self.curSortType===", self.curSortType)
end
return CommonUITestPanel
