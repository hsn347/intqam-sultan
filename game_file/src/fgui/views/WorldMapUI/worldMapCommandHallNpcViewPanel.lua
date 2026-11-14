local gametop = gModuleMgr.getObject("gametop")
local publicRead = include("publicRead")
local commandHallRead = include("commandHallRead")
local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
local commandHallUtil = include("commandHallUtil")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local worldMapCommandHallNpcViewPanel = class("worldMapCommandHallNpcViewPanel", baseFguiPanel)
function worldMapCommandHallNpcViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("worldMapCommandHallNpcViewPanel:ctor", self.viewName)
end
function worldMapCommandHallNpcViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function worldMapCommandHallNpcViewPanel:onInit()
	print("=======worldMapCommandHallNpcViewPanel:onInit")
	self.monster = nil
	self.tilePoint = nil
	self.ui = self.fields
	local ui = self.ui
	ui.Center_Node_verify:setVisible(false)
	ui.Center_Node_verify_slider:setVisible(false)
	ui.Node_addExp:setVisible(false)
	ui.Text_randomInfo:setString(i18n("commandhall_text_42"))
	self.text_talk = SoraDGetChildByName(self, "Text_monterTalk")
	self.text_talk:setNeedAutoFix(false)
	self.text_talk:setAlign(cc.TEXT_ALIGNMENT_RIGHT)
	ui.Button_attack:addClickEventListener(handler(self, self.attackButtonCallFun))
	ui.Button_attack:setCostIcon("icon_lord_sp.png", 0.8)
	self.Text_consume = ui.Button_attack
	self.fields.list:setItemRenderer(handler(self, self.onRewardRenderer))
end
function worldMapCommandHallNpcViewPanel:onShow()
	print("=======worldMapCommandHallNpcViewPanel:onShow")
end
function worldMapCommandHallNpcViewPanel:initData(mapNpc)
	self.monster = mapNpc
end
function worldMapCommandHallNpcViewPanel:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function worldMapCommandHallNpcViewPanel:getTilePoint()
	return self.tilePoint
end
function worldMapCommandHallNpcViewPanel:upateInfoPanel(taskID, taskIndex)
	self.taskID = taskID
	self.taskIndex = taskIndex
	local taskType = commandHallRead.getTaskType(self.taskID)
	self.taskType = taskType
	local npcPicture = commandHallRead.getTaskNpcPicture(taskType)
	self.ui.Image_monster:setSpriteFrame(npcPicture)
	if taskType == gCommandHallTaskType.RESCUE_TASK or taskType == gCommandHallTaskType.SNIPE_HUNTER_TASK then
		self.ui.Image_monster:setPosition(cc.p(0, -20))
	end
	local nameStr = commandHallRead.getTaskNpcName(taskType)
	self.ui.Text_monterName:setString(nameStr)
	local desStr = commandHallRead.getTaskNpcText(taskType)
	self.ui.Text_monterTalk:setString(desStr)
	local btnStr = commandHallRead.getTaskNpcButtonText(taskType)
	self.ui.Button_attack:setTitleText(btnStr)
	self:initRewards()
	self:updatePhysical()
end
function worldMapCommandHallNpcViewPanel:onRewardRenderer(index, obj)
	local data = self.rewardDatas[index + 1]
	local fields = fguiHelper.get_fields(obj)
	fields.item:initData()
	fields.item:setIcon(data[1])
	fields.title:setString(data[2])
end
function worldMapCommandHallNpcViewPanel:initRewards()
	self.rewardDatas, commandHallRead = nil, nil
	local rewards = commandHallRead.getTaskRewardNpcShow(self.taskID)
	local limitNum = #rewards
	if 5 < #rewards then
		limitNum = 4
	end
	for i = 1, limitNum do
		local itemID = rewards[i].id
		local img = publicRead.getIcon(itemID)
		local txt = publicRead.getName(itemID)
		self:addRewardOne(img, txt)
	end
	if 5 < #rewards then
		self:addRewardOne("icon_equip_storagebox.png", i18n("common_text_486"), 1.0)
	end
	self.fields.list:setNumItems(#self.rewardDatas)
end
function worldMapCommandHallNpcViewPanel:addRewardOne(img, txt, scale)
	_UPVALUE3_ = nil
	;(nil)[1] = img
	;(nil)[2] = txt
	;(nil)[3] = scale
	table.insert(self.rewardDatas, nil)
end
function worldMapCommandHallNpcViewPanel:attackButtonCallFun(ref, type)
	SoraDPlaySound()
	local dispatch = function()
		self = nil
		;(nil).toPoint = self.tilePoint
		self, (nil).dispatchType = worldMapDefine.worldMapTipButtonType_commandHallNpc, worldMapDefine.worldMapTipButtonType_commandHallNpc
		worldMapDefine.worldMapTipButtonType_commandHallNpc.commandHallTaskType = self.taskType
		;(nil).otherData, worldMapDefine.worldMapTipButtonType_commandHallNpc.commandHallTaskID = worldMapDefine.worldMapTipButtonType_commandHallNpc, self.taskID
		local armyData
		if SoraDEnoughTroops() then
			if not commandHallUtil.checkTaskTypeNeedArmy(self.taskType) then
				worldMapFunction.gotoDispatch(armyData, true)
			else
				local dispatchPanel = uiManager:show("WorldDispatchArmyView")
				dispatchPanel:initData(armyData)
			end
		else
			commandHallUtil.checkFinishGuide()
		end
	end
	if self.monster and self.monster.__cname then
		local task = commandHallCtrl:getTaskByIndex(self.taskIndex)
		if task then
			local consume = commandHallRead.getTaskConsume(self.taskID)
			if consume > self.curPhysical then
				SoraDShowMsgBox(i18n("common_text_988"), i18n("common_text_204"), nil, function(exitType)
					if exitType == MSGBOX_CALLBACK_YES then
						SoraDCreatePanel("physicalBuyView"):show()
					end
				end)
				return
			end
			if not task.isFixedTask and self.taskType ~= gCommandHallTaskType.REBEL_ARMY_GROUP_TASK and self.taskType ~= gCommandHallTaskType.REBEL_ARMY_PIONEER_TASK then
				local constantRead = include("constantRead")
				local COMMANDHALL_PROMPT_TIME = constantRead.getConstValue("COMMANDHALL_PROMPT_TIME", 0)
				local remainTime = commandHallCtrl:getTaskRefreshRemainTime()
				if COMMANDHALL_PROMPT_TIME > remainTime then
					_ENV = nil
					;(nil).time = SoraDConvertSecondToString(remainTime)
					local showMsg = i18n("commandhall_text_72", nil)
					SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(eventType)
						if eventType == MSGBOX_CALLBACK_YES then
							if tolua.isnull(self) then
								return
							end
							dispatch()
							self:close(ref, type)
						end
					end)
					return
				end
			end
			dispatch()
		end
	else
		commandHallUtil.checkFinishGuide()
	end
	self:close(ref, type)
end
function worldMapCommandHallNpcViewPanel:close()
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(nil)
end
function worldMapCommandHallNpcViewPanel:onMsgUpdateLordInfo(...)
	self:updatePhysical()
end
function worldMapCommandHallNpcViewPanel:updatePhysical(...)
	self.curPhysical = lordInfoCtrl:getBaseInfo().physical
	local consume = commandHallRead.getTaskConsume(self.taskID)
	self.Text_consume:setCostTitle(consume)
	if consume > self.curPhysical then
		self.Text_consume:setTitleColor(cc.c3b(255, 0, 0))
	else
		self.Text_consume:setTitleColor(cc.c3b(255, 255, 255))
	end
end
return worldMapCommandHallNpcViewPanel
