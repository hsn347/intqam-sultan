local activity_9001496_Ctrl = SoraDGetCtrl("activity_9001496_Ctrl")
local buildDescribeRead = include("buildDescribeRead")
local magicLampRead = include("magicLampRead")
local baseComponent = require("fgui.base.baseComponent")
local Main_taskSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001496/Main_taskSingle", Main_taskSingle)
_ENV = fgui.register_extension
fgui.register_extension.BUILD_STAR_LV = 1
local fgui.register_extension.JINN_LV, conditionType = 2, fgui.register_extension
function Main_taskSingle:onInit()
	self.fields.List1:setItemRenderer(handler(self, self.onItem1Rederer))
	self.fields.List2:setItemRenderer(handler(self, self.onItem2Rederer))
	self.fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
	self.fields.Text_get:setString(i18n("common_text_1892"))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Main_taskSingle:onShow()
end
function Main_taskSingle:onItem1Rederer(index, obj)
	local data = self.reward1[index + 1]
	obj:initData(data.id, data.count, self.data.stateLv, true)
end
function Main_taskSingle:onItem2Rederer(index, obj)
	local data = self.reward2[index + 1]
	obj:initData(data.id, data.count, self.data.statePrice, self.data.unLockPrice)
end
function Main_taskSingle:initData(data, otherData)
	self.data = data
	local cfg = data.cfg
	local stateLv = data.stateLv
	local statePrice = data.statePrice
	local btnState = data.btnState
	local ctype = cfg.lv[1]
	local bid = cfg.lv[2]
	local starLv = cfg.lv[3]
	local buildName, title1Key = "", ""
	if ctype == conditionType.BUILD_STAR_LV then
		buildName = buildDescribeRead.getName(bid)
		title1Key = "build_thriving_3"
	elseif ctype == conditionType.JINN_LV then
		buildName = magicLampRead.getJinnName(bid)
		title1Key = "build_thriving_11"
	end
	local curStarLv = data.curStarLv
	local conditionType, styles = bid, bid
	if starLv > curStarLv then
		conditionType, conditionType = nil, nil
		styles, (nil).lv, (nil).color = nil, nil, "#ff0000"
	end
	conditionType = nil
	;(nil).member = curStarLv
	;(nil).total = starLv
	local lvStr = i18n("common_text_155", nil)
	conditionType = nil
	;(nil).build = buildName
	;(nil).lv = lvStr
	self.fields.title1:setString(i18n_html(title1Key, nil, styles))
	local price = cfg.price
	conditionType = i18n_html(title1Key, nil, styles)
	i18n_html(title1Key, nil, styles).num = price
	self.fields.title2:setString(i18n_html("build_thriving_4", i18n_html(title1Key, nil, styles)))
	magicLampRead = i18n_html("build_thriving_4", i18n_html(title1Key, nil, styles))
	i18n_html("build_thriving_4", i18n_html(title1Key, nil, styles))[1] = "id"
	i18n_html("build_thriving_4", i18n_html(title1Key, nil, styles))[2] = "count"
	self.reward1 = serviceFunctions.tableFormat(cfg.reward1, i18n_html("build_thriving_4", i18n_html(title1Key, nil, styles)))
	self.fields.List1:setNumItems(#self.reward1)
	magicLampRead = #self.reward1
	;(#self.reward1)[1] = "id"
	;(#self.reward1)[2] = "count"
	self.reward2 = serviceFunctions.tableFormat(cfg.reward2, #self.reward1)
	self.fields.List2:setNumItems(#self.reward2)
	if btnState == gBtnTargetStatusDef.GO then
		if stateLv == gBtnTargetStatusDef.GO then
			self.fields.Button_go:setString(i18n("common_text_477"))
		else
			self.fields.Button_go:setString(i18n("cityUp_btn_01"))
		end
		self.fields.Button_go:setBtnColorIndex(2)
		self.controllers.c1:setSelectedIndex(0)
	elseif btnState == gBtnTargetStatusDef.GET then
		self.fields.Button_go:setString(i18n("common_text_1146"))
		self.fields.Button_go:setBtnColorIndex(0)
		self.controllers.c1:setSelectedIndex(1)
	elseif btnState == gBtnTargetStatusDef.GOT then
		self.controllers.c1:setSelectedIndex(2)
	end
end
function Main_taskSingle:onClickBtnGo(...)
	SoraDPlaySound()
	local btnState = self.data.btnState
	if btnState == gBtnTargetStatusDef.GO then
		local stateLv = self.data.stateLv
		local statePrice = self.data.statePrice
		if stateLv == gBtnTargetStatusDef.GO then
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			local ctype = self.data.cfg.lv[1]
			if ctype == conditionType.BUILD_STAR_LV then
				_ENV = nil
				;(nil).bid = self.data.cfg.lv[2]
				mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.BUILDSTAR_UPGRADE, nil)
			elseif ctype == conditionType.JINN_LV then
				mildGuideManager:starToUpgradeMagicLamp()
			end
			SoraDRemoveAllPanelFromManager()
		elseif statePrice == gBtnTargetStatusDef.GO then
			_ENV = self.data.cfg.lv[1]
			self.data.cfg.lv[1].msg = "MESSAGE_ACTIVITY_9001496_JUMP_GIFT"
			SoraDSendMessage(self.data.cfg.lv[1])
		end
	elseif btnState == gBtnTargetStatusDef.GET then
		activity_9001496_Ctrl:reqReward(self.data.cfg.index)
		local proxy = uiManager:getProxy("Activity_9001496_Main")
		if proxy then
			proxy:showLoading()
		end
	end
end
return Main_taskSingle
