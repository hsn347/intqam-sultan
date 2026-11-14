local nebulaEmperorUtil = include("nebulaEmperorUtil")
local nebulaEmperorRead = include("nebulaEmperorRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorTitlePanel = class("NebulaEmperorTitlePanel", baseFguiPanel)
function NebulaEmperorTitlePanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaEmperorTitlePanel:ctor", self.viewName)
end
function NebulaEmperorTitlePanel:onInit()
	print("=======NebulaEmperorTitlePanel:onInit")
	local handlerHelp = nebulaEmperorUtil.getHandler_onClickHelp()
	self.fields.Com_title:initData(i18n("nebulaemperor_text_19"), handler(self, self.onClickClose), handlerHelp)
	self.fields.Text_des:setString(i18n("nebulaemperor_text_145"))
	_UPVALUE3_ = self.fields.Text_des
	self.fields.Text_des[1] = self.fields.Com_lord
	self.fields.Text_des[2] = self.fields.Com_area
	self.fields.Text_des[3] = self.fields.Com_box
	for i, v in ipairs(self.fields.Text_des) do
		self:initCellTitle(v, i)
	end
	self.fields.List_lord:setItemRenderer(handler(self, self.onLordItemRenderer))
	self.fields.List_area:setItemRenderer(handler(self, self.onAreaItemRenderer))
	self.fields.List_box:setItemRenderer(handler(self, self.onBoxItemRenderer))
end
function NebulaEmperorTitlePanel:onShow()
	print("=======NebulaEmperorTitlePanel:onShow")
	self.lordList = nebulaEmperorRead.getOfficerList(gLegendBuffType.PLAYER)
	self.areaList = nebulaEmperorRead.getOfficerList(gLegendBuffType.KINGDOM)
	self.boxList = nebulaEmperorRead.getPackageList()
	self.fields.List_lord:setNumItems(#self.lordList)
	self.fields.List_area:setNumItems(#self.areaList)
	self.fields.List_box:setNumItems(#self.boxList)
end
function NebulaEmperorTitlePanel:initCellTitle(widget, index)
	_ENV, _ENV = nil, nil
	;(nil).title = i18n("nebulaemperor_text_146")
	_ENV, (nil)[1], (nil).help = nil, nil, i18n("nebulaemperor_text_147")
	;(nil).title = i18n("nebulaemperor_text_148")
	_ENV, (nil)[2], (nil).help = nil, nil, i18n("nebulaemperor_text_149")
	;(nil).title = i18n("nebulaemperor_text_150")
	;(nil)[3], (nil).help = nil, i18n("nebulaemperor_text_151")
	local config
	local cfg = config[index]
	widget:setString(cfg.title)
	widget:getChild("Button_help"):addClickListener(function()
		SoraDPlaySound()
		SoraDShowHelpMsgTip(cfg.help)
	end)
end
function NebulaEmperorTitlePanel:onLordItemRenderer(index, obj)
	local officerID = self.lordList[index + 1]
	obj:updateTitle(officerID)
end
function NebulaEmperorTitlePanel:onAreaItemRenderer(index, obj)
	local officerID = self.areaList[index + 1]
	obj:updateTitle(officerID)
end
function NebulaEmperorTitlePanel:onBoxItemRenderer(index, obj)
	local giftID = self.boxList[index + 1]
	local cfg = nebulaEmperorRead.getPackageConfig(giftID)
	obj:addClickListener(function()
		_ENV = nil
		;(nil).giftID = giftID
		uiManager:show("NebulaEmperorTitleBox", nil)
	end)
	local _fields = fguiHelper.get_fields(obj)
	_fields.icon:setURL(cfg.icon)
	_fields.Text_name:setString(i18n(cfg.name))
	nebulaEmperorRead = i18n(cfg.name)
	i18n(cfg.name).num = cfg.num
	_fields.Text_num:setString(i18n("nebulaemperor_text_235", i18n(cfg.name)))
end
return NebulaEmperorTitlePanel
