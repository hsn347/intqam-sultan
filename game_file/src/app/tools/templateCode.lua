local templateCodeSuper = class("templateCodeSuper")
local templateCode = class("templateCode", templateCodeSuper)
function templateCode:ctor(...)
	templateCode.super.ctor(self, ...)
end
function templateCode:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function templateCode:onInit()
	SoraDCreatePanel("xxxxxxxx"):show()
	local xxxxxxxx = gModuleMgr.sharedMgr("xxxxxxxx")
	local xxxxxxxx = SoraDGetCtrl("xxxxxxxx")
	local xxxxxxxx = include("xxxxxxxx")
	_ENV = nil
	;(nil).msg = "xxxxxxxxxxx"
	SoraDSendMessage(nil)
	local gametop = gModuleMgr.getObject("gametop")
	local selfUid = gametop.playertop_:getPlayerID()
	local selfUid = SoraDGetPlayerID()
	self.fields.Com_title:initData(i18n("xxxxxxxx"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	_UPVALUE2_ = self.activityID
	self.activityID[1] = "id"
	self.activityID[2] = "count"
	local rewards = serviceFunctions.tableFormat(cfg.reward, self.activityID)
	SoraDMailGainItems(rewards, true)
	local frameName = string.format("shengyan%02d", i)
	local imageName = string.format("#shengyan%02d_%02d.png", i, 1)
	local sprite_1 = display.newSprite(imageName)
	sprite_1:setPosition(cc.p(0, 0))
	sprite_1:addTo(self, -1)
	local frames = display.newFrames(frameName .. "_%02d.png", 1, 12)
	local animation = display.newAnimation(frames, 0.13333333333333333)
	sprite_1:playAnimationForever(animation)
	local obj = fgui.UIPackage:createObjectFromURL("ui://SoldierRush/Com_arrow")
	local obj = fgui.UIPackage:createObject("SoldierRush", "Com_arrow")
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onMsgUpdateItemCount))
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	backpackCtrl:addItemChangeEvent(300501, handler(self, self.notifyItemCount))
	_ENV = handler(self, self.notifyItemCount)
	handler(self, self.notifyItemCount).content = i18n("content")
	handler(self, self.notifyItemCount).cancel = true
	handler(self, self.notifyItemCount).confirmFunc = function()
	end
	handler(self, self.notifyItemCount).remindString = i18n("coffeeCraftsman_text_27")
	handler(self, self.notifyItemCount).remindFunc = function(value)
	end
	uiManager:show("MessageBox", handler(self, self.notifyItemCount))
end
function templateCode:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("xxxxxxxx")
	uiManager:show("RuleView", nil)
end
function templateCode:initButtonTest()
	self.fields.Button_normal:addClickListener(handler(self, self.onClickBtnNormal))
	self.fields.Panel_move:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onEventTouchBegin))
	self.fields.Panel_move:addEventListener(fgui.UIEventType.TouchMove, handler(self, self.onEventTouchMove))
	self.fields.Panel_move:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onEventTouchEnd))
end
function templateCode:onClickBtnNormal(...)
	SoraDPlaySound()
end
function templateCode:onClickBtnNormal(EventContext)
	SoraDPlaySound()
	local button = EventContext:getSender()
end
function templateCode:onEventTouchBegin(context)
	context:captureTouch()
	local _toPos = context:getInput():getPosition()
end
function templateCode:onEventTouchMove(context)
	local _toPos = context:getInput():getPosition()
end
function templateCode:onEventTouchEnd(context)
	local _toPos = context:getInput():getPosition()
end
function templateCode:initListTest()
	self.fields.List:setItemProvider(handler(self, self.onItemProvider))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	self.fields.List:setNumItems(#self.dataList)
	self.fields.List:resizeToFit(#self.dataList)
	self.fields.List:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
end
function templateCode:onItemProvider(index)
	if index == 0 then
		return "ui://xxxx/xxxxx0"
	else
		return "ui://xxxx/xxxxx1"
	end
end
function templateCode:onItemRenderer(index, obj)
	local data = self.dataList[index + 1]
	obj:initData(data)
end
function templateCode:onItemRenderer(index, obj)
	local _fields = obj._fields
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
	end
	local data = self.dataList[index + 1]
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local rewards = serviceFunctions.tableFormat(data.rewards, nil)
	_fields.List:setItemRenderer(function(_index, _obj)
		local _data = rewards[_index + 1]
		_obj:initData(_data.id, _data.count)
	end)
	_fields.List:setNumItems(#rewards)
end
function templateCode:onPullUpRelease(...)
	if self.hasMore then
		self:req4Data()
	end
end
function templateCode:onClickItem(EventContext)
	SoraDPlaySound()
	local obj = EventContext:getGObjectData()
	local childIndex = self.fields.List:getChildIndex(obj)
	local itemIndex = self.fields.List:childIndexToItemIndex(childIndex)
end
function templateCode:initTabListTest(...)
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, nil, 1
	_ENV, (nil)[1], (nil).title = nil, nil, i18n("xxx1")
	;(nil).tabsetArray, (nil)[2], (nil).title = nil, nil, i18n("xxx2")
	local (nil).callback, param = handler(self, self.onClickTab), nil
	self.fields.com_Tab:initView(param)
end
function templateCode:onClickTab(tag)
	self.curTag = tag
end
function templateCode:initComboBoxTest(...)
	_ENV = nil
	;(nil)[VIEW_SUB_TYPE.TYPE_MEMBER] = i18n("common_text_3079")
	local (nil)[VIEW_SUB_TYPE.TYPE_FRIEND], config = i18n("friend_name_01"), nil
	_ENV = nil
	;(nil).items = config
	;(nil).changedCallback = handler(self, self.onComboBoxChanged)
	;(nil).selectedIndex = self.showViewSubType - 1
	self:setComboBox(self.fields.ComboBox_invite, nil)
	local dropdown = self.fields.ComboBox_invite:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox_invite:addClickListener(function()
		self.comboBoxList:setSelectedIndex(self.showViewSubType - 1)
	end)
	self.fields.ComboBox_invite:fixPos()
	self.fields.ComboBox_invite:fixChildrenPos()
end
function templateCode:onComboBoxChanged()
	local index = self.fields.ComboBox_invite:getSelectedIndex()
	self.showViewSubType = index + 1
end
function templateCode:initActivityStateChangeTest(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.onMsgCommonRefresh))
end
function templateCode:judgeClose(target, event)
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function templateCode:onMsgCommonRefresh(target, event)
	local activityID = event.activityID
	if not activityID or type(activityID) ~= "table" or not table.indexof(activityID, self.activityID) then
		return
	end
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
		return
	end
end
function templateCode:onMsgUpdateActivityNew(...)
	self.view:onMsgUpdateActivityNew(...)
end
function templateCode:initNewDayTest(...)
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.onMsgNewDay))
end
function templateCode:onMsgNewDay(...)
	self.view:onMsgNewDay(...)
end
function templateCode:loadShader()
	_ENV, _ENV = nil, nil
	;(nil).attr = "texture"
	;(nil).name = "u_texture"
	;(nil).value = "3DTexture/hero/light1.png"
	_UPVALUE4_, (nil).hasMipmap = nil, false
	_ENV, (nil)[1], (nil).texParam, (nil)[1] = nil, nil, nil, gl.LINEAR
	_ENV, (nil)[1], (nil).texParam, (nil)[2] = nil, nil, nil, gl.LINEAR
	_ENV, (nil)[1], (nil).texParam, (nil)[3] = nil, nil, nil, gl.REPEAT
	_ENV, (nil)[1], (nil).texParam, (nil)[4] = nil, nil, nil, gl.REPEAT
	;(nil).attr = "#texture"
	;(nil).name = "u_texture"
	;(nil).value = self.renderTexture:getSprite():getTexture()
	_ENV, (nil)[2], (nil).hasMipmap = nil, nil, false
	;(nil).attr = "float"
	;(nil).name = "u_float"
	_ENV, (nil)[3], (nil).value = nil, nil, 1.0
	;(nil).attr = "floatv"
	_UPVALUE3_, (nil).name = self.renderTexture:getSprite():getTexture(), "u_floatv"
	_ENV, (nil)[4], (nil).value, self.renderTexture:getSprite():getTexture()[1] = nil, nil, self.renderTexture:getSprite():getTexture(), 1.0
	_ENV, (nil)[4], (nil).value, self.renderTexture:getSprite():getTexture()[2] = nil, nil, self.renderTexture:getSprite():getTexture(), 1.0
	_ENV, (nil)[4], (nil).value, self.renderTexture:getSprite():getTexture()[3] = nil, nil, self.renderTexture:getSprite():getTexture(), 0.0
	;(nil).attr = "vec2"
	_ENV, (nil).name = self.renderTexture:getSprite():getTexture(), "u_vec2"
	self.renderTexture:getSprite():getTexture().x = 1
	_ENV, (nil)[5], (nil).value, self.renderTexture:getSprite():getTexture().y = nil, nil, self.renderTexture:getSprite():getTexture(), 1
	;(nil).attr = "vec3"
	_ENV, (nil).name = self.renderTexture:getSprite():getTexture(), "u_vec3"
	self.renderTexture:getSprite():getTexture().x = 1
	self.renderTexture:getSprite():getTexture().y = 1
	_ENV, (nil)[6], (nil).value, self.renderTexture:getSprite():getTexture().z = nil, nil, self.renderTexture:getSprite():getTexture(), 0
	;(nil).attr = "vec4"
	_ENV, (nil).name = self.renderTexture:getSprite():getTexture(), "u_vec4"
	self.renderTexture:getSprite():getTexture().x = 1
	self.renderTexture:getSprite():getTexture().y = 1
	self.renderTexture:getSprite():getTexture().z = 0
	_ENV, (nil)[7], (nil).value, self.renderTexture:getSprite():getTexture().w = nil, nil, self.renderTexture:getSprite():getTexture(), 0
	;(nil).attr = "timeuv"
	_ENV, (nil).name = self.renderTexture:getSprite():getTexture(), "u_timeuv"
	self.renderTexture:getSprite():getTexture().kU = 0.0
	;(nil)[8], (nil).value, self.renderTexture:getSprite():getTexture().kV = nil, self.renderTexture:getSprite():getTexture(), 1.0
	local params
	local shaderGroup = require("app.shader.shader")
	local program = cc.GLProgram:createWithByteArrays(shaderGroup.vertBytes, shaderGroup.fragBytes)
	local state = cc.GLProgramState:create(program)
	SoraDSetProgramStateParam(program, state, params)
	self.program = program
	self.state = state
	self.sprite_bg:setGLProgramState(state)
end
function templateCode:defineValue(...)
	templateCode:defineValue("xxx_xxx_xxx", function()
		local baseConfig = require_data("xxx_xxx_xxx", true).data
		return templateCode.getClassTypeConfig(baseConfig, "classtype")
	end)
	function _UPVALUE2_()
		local baseConfig = require_data("xxx_xxx_xxx", true).data
		return templateCode.getClassTypeConfig(baseConfig, "classtype")
	end
	;(function()
		local baseConfig = require_data("xxx_xxx_xxx", true).data
		return templateCode.getClassTypeConfig(baseConfig, "classtype")
	end)[1] = "xxx_xxx_xxx"
	;(function()
		local baseConfig = require_data("xxx_xxx_xxx", true).data
		return templateCode.getClassTypeConfig(baseConfig, "classtype")
	end)[2] = true
	templateCode:defineValue("xxx_xxx_xxx", function()
		local baseConfig = require_data("xxx_xxx_xxx", true).data
		return templateCode.getClassTypeConfig(baseConfig, "classtype")
	end)
end
function templateCode:onRegisterEvent(...)
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001700_UPDATE", handler(self, self.onMsgUpdateData))
end
function templateCode:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
function templateCode:onMsgUpdateData(target, event)
	local subMsg = event.subMsg
	if subMsg == "questReward" then
		self:updateTaskList()
	elseif subMsg == "buyGift" then
		self:updateTaskList()
	end
end
return templateCode
