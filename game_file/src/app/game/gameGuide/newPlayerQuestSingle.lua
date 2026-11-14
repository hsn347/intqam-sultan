local gametop = gModuleMgr.getObject("gametop")
local newPlayerTaskCtrl = gametop.playertop_:getModule("newPlayerTaskCtrl")
local newPlayerTaskRead = include("newPlayerTaskRead")
local NewPlayerQuestSingle = class("newPlayerQuestSingle", function(target)
	if target == nil then
		print("纯控制类")
	end
	return target
end)
function NewPlayerQuestSingle:ctor()
	self.qid = 0
	self.nodeBtn = SoraDGetChildByName(self, "Node_btn")
	self.btnJump = SoraDGetChildByName(self, "Button_jump")
	self.btnGet = SoraDGetChildByName(self, "Button_get")
	self.Node_exp = SoraDGetChildByName(self, "Node_exp")
	self.labelExp = SoraDGetChildByName(self, "Text_exp")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.nodeGet = SoraDGetChildByName(self, "Node_get")
	self.labelGet = SoraDGetChildByName(self, "Text_get")
	self.labelGet:setString(i18n("common_text_1892"))
	self.imgNormal = SoraDGetChildByName(self, "Image_normal")
	self.imgGray = SoraDGetChildByName(self, "Image_gray")
	if self.btnGet then
		self.btnGet:addTouchEventListener(handler(self, self.btnClickCallBack))
		self.btnJump:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function NewPlayerQuestSingle:initData(qid)
	self.qid = qid
	if newPlayerTaskCtrl:isTaskRewardCanReceive(self.qid) then
		self.btnGet:setVisible(false)
		self.btnJump:setVisible(false)
		self.nodeGet:setVisible(true)
		self.nodeBtn:setVisible(false)
		self.imgNormal:setVisible(false)
		self.imgGray:setVisible(true)
		self.labelDes:setColor(cc.c3b(112, 107, 96))
		self.labelName:setColor(cc.c3b(112, 107, 96))
	else
		self.btnGet:setVisible(true)
		self.btnJump:setVisible(true)
		self.nodeGet:setVisible(false)
		self.nodeBtn:setVisible(true)
		self.imgNormal:setVisible(true)
		self.imgGray:setVisible(false)
		if SoraDFIsRA() then
			self.labelExp:setString(string.formatnumberthousands(newPlayerTaskRead.getRewardByTaskID(self.qid)[2]) .. " +")
		else
			self.labelExp:setString("+ " .. string.formatnumberthousands(newPlayerTaskRead.getRewardByTaskID(self.qid)[2]))
		end
		SoraDToCenter(self.Node_exp)
		if newPlayerTaskCtrl:isTaskFinish(self.qid) then
			self.btnJump:setVisible(false)
			self.btnGet:loadTextureNormal("btn_zjjl_lingqu.png", ccui.TextureResType.plistType)
			self.btnGet:setCapInsets(cc.rect(18, 5, 21, 47))
			self.btnGet:setTitleText(i18n("common_text_1146"))
		else
			self.btnGet:loadTextureNormal("btn_zjjl_go.png", ccui.TextureResType.plistType)
			self.btnGet:setCapInsets(cc.rect(18, 5, 21, 47))
			self.btnGet:setTitleText(i18n("common_text_477"))
		end
		self.labelName:setColor(cc.c3b(70, 15, 0))
		self.labelDes:setColor(cc.c3b(110, 70, 40))
	end
	local singleData = newPlayerTaskCtrl:getTaskInfo()[tostring(self.qid)]
	if singleData then
		newPlayerTaskCtrl = cc.c3b(110, 70, 40)
		cc.c3b(110, 70, 40).count = singleData.finishCount
		cc.c3b(110, 70, 40).total = singleData.maxCount
		self.labelDes:setString(i18n("common_text_3683", cc.c3b(110, 70, 40)))
	end
	self.labelName:setString(newPlayerTaskRead.getDesByTID(self.qid))
end
function NewPlayerQuestSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if newPlayerTaskCtrl:isTaskFinish(self.qid) then
			newPlayerTaskCtrl:sendReceiveTaskReward(self.qid)
			if self.qid == 4103412 then
				local guideCtrl = gametop.playertop_:getModule("guideCtrl")
				guideCtrl:updateGuideModule(gGuideModule.MAIL)
			end
		elseif SoraDIsGameGuide() == nil then
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			local qData = newPlayerTaskRead.getCondition(self.qid)
			local qtype = qData.questType
			print("qtype========", self.qid, qtype)
			dump(qData)
			local ret, notNeedClose = mildGuideManager:starMildByNewPlayerQuestID(qtype, qData)
			if not notNeedClose then
				SoraDRemoveAllPanelFromManager()
			end
		else
			SoraDRemoveAllPanelFromManager()
		end
	end
end
return NewPlayerQuestSingle
