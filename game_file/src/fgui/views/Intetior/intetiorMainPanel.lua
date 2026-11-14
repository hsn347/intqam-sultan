local baseFguiPanel = require("fgui.base.baseFguiPanel")
local intetiorMainPanel = class("intetiorMainPanel", baseFguiPanel)
function intetiorMainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("intetiorMainPanel:ctor", self.viewName)
end
function intetiorMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function intetiorMainPanel:onInit()
	print("=======intetiorMainPanel:onInit")
	self.fields.Com_title:initData(i18n("parliament_name_01"), handler(self, self.onClickClose), handler(self, self.btnHelpClick))
	_ENV = self.fields.Com_title.initData
	_ENV, _ENV, self.fields.Com_title.initData.defaultClick = i18n("parliament_name_01"), self.fields.Com_title, 1
	i18n("parliament_name_01").title = i18n("parliament_btn_04")
	_ENV, self.fields.Com_title[1], i18n("parliament_name_01").tag = i18n("parliament_name_01"), i18n("parliament_name_01"), 1
	i18n("parliament_name_01").title = i18n("parliament_btn_05")
	_ENV, self.fields.Com_title[2], i18n("parliament_name_01").tag = i18n("parliament_name_01"), i18n("parliament_name_01"), 2
	i18n("parliament_name_01").title = i18n("parliament_btn_06")
	self.fields.Com_title.initData.tabsetArray, self.fields.Com_title[3], i18n("parliament_name_01").tag = self.fields.Com_title, i18n("parliament_name_01"), 3
	local self.fields.Com_title.initData.callback, tableData = handler(self, self.onClickTab), self.fields.Com_title.initData
	self.fields.Com_tab:initView(tableData)
end
function intetiorMainPanel:onShow()
	print("=======intetiorMainPanel:onShow")
end
function intetiorMainPanel:onClickTab(tag)
	self.controllers.c1:setSelectedIndex(tag - 1)
end
function intetiorMainPanel:btnHelpClick()
	_UPVALUE5_ = "parliament_text_03"
	;("parliament_text_03")[1] = i18n("parliament_btn_01")
	;("parliament_text_03")[2] = i18n("parliament_text_04")
	;("parliament_text_03")[3] = i18n("parliament_btn_02")
	;("parliament_text_03")[4] = i18n("parliament_text_05")
	;("parliament_text_03")[5] = i18n("parliament_btn_03")
	;("parliament_text_03")[6] = i18n("parliament_text_06")
	;("parliament_text_03")[7] = i18n("parliament_text_06")
	_ENV = i18n("parliament_text_04")
	i18n("parliament_text_04").hideBtn = true
	i18n("parliament_text_04").height = 660
	SoraDShowFixWindow(i18n("parliament_text_03"), "parliament_text_03", nil, (i18n("parliament_text_04")))
end
return intetiorMainPanel
