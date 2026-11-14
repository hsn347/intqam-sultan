local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonViewDemoPanel = class("CommonViewDemoPanel", baseFguiPanel)
function CommonViewDemoPanel:ctor(...)
	self.isLRU = true
	CommonViewDemoPanel.super.ctor(self, ...)
	print("CommonViewDemoPanel:ctor", self.viewName)
end
function CommonViewDemoPanel:onInit()
	print("=======CommonViewDemoPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initData(i18n("CommonViewDemo"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_cost:setString(i18n("按钮1"))
	self.fields.Button_cost:addClickListener(handler(self, self.btnCostClick))
	self.fields.Button_normal:setString(i18n("按钮2"))
	self.fields.Button_normal:addClickListener(handler(self, self.btnNormalClick))
	self.fields.Button_price:setString(i18n("按钮3"))
	self.fields.Button_price:addClickListener(handler(self, self.btnPriceClick))
	self.fields.Button_small:setString(i18n("按钮4"))
	self.fields.Button_small:addClickListener(handler(self, self.btnSmallClick))
	self.fields.Button_style:setString(i18n("按钮5"))
	self.fields.Button_style:addClickListener(handler(self, self.btnStyleClick))
	self.fields.Button_recharge:addClickListener(handler(self, self.btnRechargeClick))
	self.fields.Text_tip:setString(i18n("测试文本"))
	self.input = self.fields.input:getChild("input")
	self.input:setPromptHolder("默认文本")
	self.fields.Com_slider:setSliderCallBack(handler(self, self.onSliderBack))
	self.fields.List_item:setVirtual()
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRenderer))
end
function CommonViewDemoPanel:onItemRenderer(index, obj)
	obj:initData(self.itemData[index + 1].id, self.itemData[index + 1].count)
end
function CommonViewDemoPanel:onSliderBack(value)
	print("onSliderBack===", value)
end
function CommonViewDemoPanel:btnCostClick()
	SoraDPlaySound()
	print("按钮1点击")
end
function CommonViewDemoPanel:btnNormalClick()
	SoraDPlaySound()
	print("按钮2点击")
end
function CommonViewDemoPanel:btnPriceClick()
	SoraDPlaySound()
	print("按钮3点击")
end
function CommonViewDemoPanel:btnSmallClick()
	SoraDPlaySound()
	print("按钮4点击")
end
function CommonViewDemoPanel:btnRechargeClick()
	SoraDPlaySound()
	print("充值按钮点击")
end
function CommonViewDemoPanel:btnStyleClick()
	SoraDPlaySound()
	print("按钮5点击")
end
function CommonViewDemoPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("帮助说明")
	uiManager:show("RuleView", nil)
end
function CommonViewDemoPanel:endShow()
	print("=======CommonViewDemoPanel:endShow")
	self.fields.Bar_test:setMax(100)
	self.fields.Bar_test:setTitleType(fgui.ProgressTitleType.PERCENT)
	self.fields.Label_title:setString(i18n("小标题"))
	self:initBoxList()
	self:initComboBox()
	self.fields.Label_timer:setTimeLast(function(time)
		return fguiHelper.getColorString("#FFC864", i18n("common_text_2669")) .. fguiHelper.getColorString("#FFFFFF", time)
	end)
	self.fields.Label_timer:beginTime(86426)
	self.tag = 1
	_ENV = 86426
	_ENV, _ENV, (86426).defaultClick = i18n("小标题")
	i18n("小标题").title = i18n("分页1")
	_ENV, self.tag[1], i18n("小标题").tag = i18n("小标题")
	i18n("小标题").title = i18n("分页2")
	;(86426).tabsetArray, self.tag[2], i18n("小标题").tag = self.tag, i18n("小标题")
	;(86426).callback = handler(self, self.onClickTab)
	self.fields.com_Tab:initView(86426)
end
function CommonViewDemoPanel:onClickTab(tag)
	self.tag = tag
	self:updateUI()
end
function CommonViewDemoPanel:initComboBox()
	_UPVALUE3_, self.comboBoxType = nil, 1
	_UPVALUE3_, (nil)[1] = "品质", "品质"
	_UPVALUE3_, (nil)[2] = "品质", "等级"
	local _UPVALUE3_, (nil)[3], items = "品质", "稀有度", nil
	;("品质")[1] = 1
	;("品质")[2] = 2
	local ("品质")[3], values = 3, "品质"
	_ENV = nil
	;(nil).items = items
	;(nil).values = values
	;(nil).changedCallback = handler(self, self.onComboBoxClick)
	self:setComboBox(self.fields.comboBox, nil)
	local dropdown = self.fields.comboBox:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.comboBox:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxList:setSelectedIndex(self.comboBoxType - 1)
	end)
	self.fields.comboBox:fixChildrenPos()
end
function CommonViewDemoPanel:onComboBoxClick()
	SoraDPlaySound()
	self.comboBoxType = tonumber(self.fields.comboBox:getValue())
	print("self.comboBoxType===", self.comboBoxType)
end
function CommonViewDemoPanel:initBoxList()
	local _ENV, stageData
	local _ENV, stageCfg
	for i = 1, 5 do
		_ENV = nil
		;(nil).stageId = i
		;(nil).stage = i * 100
		_UPVALUE2_ = nil
		_UPVALUE2_, (nil)[1] = 1001, 1001
		_UPVALUE2_, (nil)[2] = 1001, i
		;(1001)[1] = "id"
		;(1001)[2] = "count"
		;(nil).stageReward = serviceFunctions.tableFormat(nil, 1001)
		table.insert(stageCfg, nil)
	end
	for __, cfg in ipairs(stageCfg) do
		_ENV = serviceFunctions.tableFormat(nil, 1001)
		serviceFunctions.tableFormat(nil, 1001).stage = cfg.stageId
		serviceFunctions.tableFormat(nil, 1001).point = cfg.stage
		serviceFunctions.tableFormat(nil, 1001).rewards = cfg.stageReward
		table.insert(stageData, (serviceFunctions.tableFormat(nil, 1001)))
	end
	self.stageData = stageData
	self.fields.Com_boxList:setBarColor(3)
	_ENV = 3
	;(3).activityID = self.activityID
	;(3).stageMax = #self.stageData
	self.fields.Com_boxList:initData(3)
end
function CommonViewDemoPanel:updateBoxList()
	local point = 99
	for __, data in ipairs(self.stageData) do
		data.state = gBtnTargetStatusDef.GO
	end
	_ENV = ipairs(self.stageData)
	ipairs(self.stageData).score = point
	ipairs(self.stageData).stageData = self.stageData
	self.fields.Com_boxList:updateData(ipairs(self.stageData))
end
function CommonViewDemoPanel:updateUI()
	self.fields.Bar_test:setValue(20)
	self:updateBoxList()
	self.fields.Button_cost:setCost(876601, 1)
	self.fields.Button_price:initData(876601, 1)
	self.fields.Button_recharge:initData(99, 999)
	self.fields.Com_have:initData(876601)
	self.fields.Com_head:setHeadSprite(1505, "")
	self.fields.Com_head:setPlayerID(125)
	self.fields.Com_head:setKid(10)
	self.fields.Com_hero:initData(1700)
	self.fields.Com_item:initData(876601, 9)
	_UPVALUE0_ = 876601
	;(876601).maxValue = 999
	;(876601).minValue = 1
	;(876601).curValue = 1
	self.fields.Com_slider:initData(876601)
	_UPVALUE0_, _UPVALUE0_ = self.fields.Com_slider, self.fields.Com_slider.initData
	self.fields.Com_slider.id = 844001
	_UPVALUE0_, self.fields.Com_slider.initData[1], self.fields.Com_slider.count = self.fields.Com_slider, self.fields.Com_slider, 1
	self.fields.Com_slider.id = 12010101
	_UPVALUE0_, self.fields.Com_slider.initData[2], self.fields.Com_slider.count = self.fields.Com_slider, self.fields.Com_slider, 2
	self.fields.Com_slider.id = 5022004
	_UPVALUE0_, self.fields.Com_slider.initData[3], self.fields.Com_slider.count = self.fields.Com_slider, self.fields.Com_slider, 3
	self.fields.Com_slider.id = 7020402
	_UPVALUE0_, self.fields.Com_slider.initData[4], self.fields.Com_slider.count = self.fields.Com_slider, self.fields.Com_slider, 4
	self.fields.Com_slider.id = 218601
	_UPVALUE0_, self.fields.Com_slider.initData[5], self.fields.Com_slider.count = self.fields.Com_slider, self.fields.Com_slider, 5
	self.fields.Com_slider.id = 876601
	self.itemData, self.fields.Com_slider.initData[6], self.fields.Com_slider.count = self.fields.Com_slider.initData, self.fields.Com_slider, 6
	self.fields.List_item:setNumItems(#self.itemData)
end
return CommonViewDemoPanel
