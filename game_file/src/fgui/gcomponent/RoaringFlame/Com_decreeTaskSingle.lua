local eventQuestRead = include("eventQuestRead")
local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_decreeTaskSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/Com_decreeTaskSingle", Com_decreeTaskSingle)
function Com_decreeTaskSingle:onInit()
	self.reward, _ENV = nil, nil
	self.fields.Lab_done:setTitle(i18n("common_text_1892"))
	self.fields.Lab_done:setVisible(false)
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.btnGoClick))
	self.fields.Button_go:setVisible(false)
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixChildrenPos()
end
function Com_decreeTaskSingle:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Com_decreeTaskSingle:onShow()
end
function Com_decreeTaskSingle:initData(data)
	eventQuestRead, self.data = nil, data
	local eventQuestRead, (nil).color, tmp = nil, "#E2AF27", nil
	;(nil).var = tmp
	;(nil).power = tmp
	;(nil).num = tmp
	eventQuestRead, (nil).lv = nil, tmp
	;(nil).__default, (nil).color = nil, "#D7C39B"
	local styles
	self.fields.Text_des:setString(eventQuestRead.getDesNew(self.data.taskID, styles))
	self.reward = eventQuestRead.getReward(self.data.taskID)
	self.fields.List_reward:setNumItems(#self.reward)
	self.fields.List_reward:setScrollEnable(#self.reward > 4)
	local aim = eventQuestRead.getAim(self.data.taskID)
	local aimStr = SoraDConvertNumberWithUnit(aim)
	self.isCalimed = self.data.status == 2
	self.isReward = self.data.status == 0
	self.jumpType = roaringFlameWarRead.getJumpTypeByTaskID(self.data.taskID)
	print("self.jumpType=====", self.jumpType, self.data.taskID)
	if self.isCalimed or self.isReward then
		eventQuestRead = eventQuestRead.getDesNew(self.data.taskID, styles)
		eventQuestRead.getDesNew(self.data.taskID, styles).count = aimStr
		eventQuestRead.getDesNew(self.data.taskID, styles).total = aimStr
		self.fields.Text_progress:setString(i18n("common_text_3683", eventQuestRead.getDesNew(self.data.taskID, styles)))
		self.fields.Text_progress:setColor(self.isCalimed and cc.c3b(215, 195, 155) or cc.c3b(109, 222, 0))
		self.fields.Lab_done:setVisible(self.isCalimed)
		self.fields.Button_go:setString(i18n("common_text_1146"))
		self.fields.Button_go:setVisible(self.isReward)
		self.fields.Button_go:setBtnColorIndex(gBtnColorDef.GREEN)
	else
		self.fields.Lab_done:setVisible(false)
		self.fields.Button_go:setString(i18n("common_text_477"))
		self.fields.Button_go:setVisible(self.jumpType and 0 < self.jumpType)
		self.fields.Button_go:setBtnColorIndex(gBtnColorDef.YELLOW)
		self.fields.Text_progress:setColor(cc.c3b(215, 195, 155))
		local _count = SoraDConvertNumberWithUnit(math.floor(self.data.progress) or 0)
		local count = fguiHelper.getColorString("#BE2828", _count)
		eventQuestRead = cc.c3b(215, 195, 155)
		cc.c3b(215, 195, 155).count = count
		cc.c3b(215, 195, 155).total = aimStr
		self.fields.Text_progress:setString(i18n("common_text_3683", cc.c3b(215, 195, 155)))
	end
end
function Com_decreeTaskSingle:btnGoClick()
	SoraDPlaySound()
	if self.isReward then
		roaringFlameWarCtrl:reqQuestRewardNotice(self.data.taskID)
	elseif worldMapDefine.isInRoaringFlame() then
		local jumpType = self.jumpType or gRoaringFlameWarDecreeTaskEnum.toWorld
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		if jumpType == gRoaringFlameWarDecreeTaskEnum.toWorld then
			SoraDGotoWorldMapPoint()
			SoraDRemoveAllPanelFromManager()
		elseif jumpType == gRoaringFlameWarDecreeTaskEnum.toWorldMonster then
			SoraDRemoveAllPanelFromManager()
			_ENV = nil
			;(nil).chooseIndex = 200
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.QUICK_TO_WORLD_KILL_MONSTER, nil)
		elseif jumpType == gRoaringFlameWarDecreeTaskEnum.toWorldPhoenix then
			SoraDRemoveAllPanelFromManager()
			_ENV = nil
			;(nil).chooseIndex = 201
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.QUICK_TO_WORLD_KILL_MONSTER, nil)
		elseif jumpType == gRoaringFlameWarDecreeTaskEnum.toWorldRes then
			SoraDRemoveAllPanelFromManager()
			_ENV = nil
			;(nil).chooseIndex = 203
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.QUICK_TO_WORLD_KILL_MONSTER, nil)
		elseif jumpType == gRoaringFlameWarDecreeTaskEnum.toWorldGold then
			SoraDRemoveAllPanelFromManager()
			_ENV = nil
			;(nil).chooseIndex = 202
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.QUICK_TO_WORLD_KILL_MONSTER, nil)
		elseif jumpType == gRoaringFlameWarDecreeTaskEnum.toHospital then
			uiManager:show("HospitalView"):setLV(nil, gKingdomClassType.roaringFlame)
		elseif jumpType == gRoaringFlameWarDecreeTaskEnum.toWorldCenter then
			SoraDGotoWorldMapPoint(roaringFlameWarRead.getBuildServerCoord(roaringFlameWarUtil.getPalaceBuildID()))
			SoraDRemoveAllPanelFromManager()
		end
	else
		SoraDShowMsgTip(i18n("brightWar_text_79"))
	end
end
return Com_decreeTaskSingle
