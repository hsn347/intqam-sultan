local magicLampSkillRead = include("magicLampSkillRead")
local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampSkillAdvancePanel = class("MagicLampSkillAdvancePanel", baseFguiPanel)
function MagicLampSkillAdvancePanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampSkillAdvancePanel:ctor", self.viewName)
	self.chooseList, _ENV, self.data = self.proxy.param.data, self.proxy.param.data, self.proxy.param.data
	self.isHidePrePanel = true
end
function MagicLampSkillAdvancePanel:onInit()
	print("=======MagicLampSkillAdvancePanel:onInit")
	self.fieldsCur = fguiHelper.get_fields(self.fields.Com_skillCur)
	self.fieldsNext = fguiHelper.get_fields(self.fields.Com_skillNext)
	self.fields.Com_title:setString(i18n("jinn_skill_26"))
	self.fields.List_skill:setItemRenderer(handler(self, self.onSkillItemRenderer))
	self.fields.Button_upgrade:setString(i18n("common_text_2921"))
	self.fields.Button_upgrade:addClickListener(handler(self, self.onClickBtnUpgrade))
	self.fields.Button_upgrade:setBright(false)
	self.fields.Button_auto:setString(i18n("jinn_skill_35"))
	self.fields.Button_auto:addClickListener(handler(self, self.onClickBtnAuto))
	self.fields.Text_return:setString(i18n("jinn_skill_29"))
	self.fields.Com_mark:setVisible(false)
	if not SoraDFIsRA() then
		self.fields.Com_skillCur:fixPos()
		self.fields.Com_skillNext:fixPos()
		_UPVALUE3_ = self.fields.Com_skillNext
		self.fields.Com_skillNext[1] = self.fields.Com_arrow1
		self.fields.Com_skillNext[2] = self.fields.Com_arrow2
		self.fields.Com_skillNext[3] = self.fields.Com_arrow3
		for i, v in ipairs(self.fields.Com_skillNext) do
			v:getController("c2"):setSelectedIndex(SoraDFIsRA() and 0 or 1)
		end
	end
end
function MagicLampSkillAdvancePanel:onShow()
	print("=======MagicLampSkillAdvancePanel:onShow")
	self:updateSkillLv()
	local group = magicLampSkillRead.getSkillStageGroup(self.data.skillType)
	local needSkill = magicLampSkillRead.getAdvanceNeedSkill(group, self.data.classLv + 1)
	dump(needSkill, "==needSkill==")
	_ENV, _ENV = needSkill, dump
	needSkill.type = 1
	needSkill.classLv = 0
	needSkill.count = 1
	_ENV, dump[1], needSkill.value = needSkill, needSkill, 1
	needSkill.type = 2
	needSkill.classLv = 0
	needSkill.count = 1
	_ENV, dump[2], needSkill.value = needSkill, needSkill, 3
	needSkill.type = 2
	needSkill.classLv = 0
	needSkill.count = 1
	dump[3], needSkill.value = needSkill, 2
	local _needSkill = dump
	self.needSkill = needSkill
	self.fields.List_skill:setNumItems(#self.needSkill)
end
function MagicLampSkillAdvancePanel:onClickBtnUpgrade(...)
	SoraDPlaySound()
	local _ENV, costList = SoraDPlaySound, SoraDPlaySound
	for k, v in pairs(self.chooseList) do
		table.insertto(costList, v)
	end
	if #costList == 0 or not self:checkNeedSkillEnough() then
		SoraDShowMsgTip(i18n("jinn_skill_30"))
		return
	end
	if magicLampSkillRead.checkQualityNeedNote(costList) then
		SoraDShowMsgBox(i18n("jinn_skill_33"), i18n("common_text_204"), i18n("common_text_185"), function(exitType)
			if MSGBOX_CALLBACK_YES == exitType then
				magicLampSkillCtrl:reqUpgradeClass(self.data.id, costList)
				SoraDShowLoading(self:displayObject())
			end
		end)
	else
		magicLampSkillCtrl:reqUpgradeClass(self.data.id, costList)
		SoraDShowLoading(self:displayObject())
	end
end
function MagicLampSkillAdvancePanel:onClickBtnAuto(...)
	SoraDPlaySound()
	if self:checkNeedSkillEnough() then
		return
	end
	local enough, chooseList = magicLampSkillCtrl:getAutoChooseList(self.needSkill, self.data, self.chooseList)
	if enough then
		self.chooseList = chooseList
		dump(self.chooseList, "==self.chooseList==")
		SoraDShowMsgTip(i18n("jinn_skill_36"))
		self.fields.List_skill:setNumItems(#self.needSkill)
		self.fields.Button_upgrade:setBright(true)
		self:updateTextReturn()
	else
		SoraDShowMsgTip(i18n("jinn_skill_31"))
	end
end
function MagicLampSkillAdvancePanel:updateSkillLv(...)
	self:updateComSkill(self.fieldsCur, self.data)
	local nextData = clone(self.data)
	nextData.classLv = nextData.classLv + 1
	self:updateComSkill(self.fieldsNext, nextData)
end
function MagicLampSkillAdvancePanel:updateComSkill(fields, data)
	_ENV = nil
	;(nil).lv = data.classLv
	fields.Text_classLv:setString(i18n("jinn_skill_27", nil))
	fields.Com_skill:initData(data)
	local group = magicLampSkillRead.getSkillStageGroup(data.skillType)
	local lvLimit = magicLampSkillRead.getStageLvLimit(group, data.classLv)
	_ENV = i18n("jinn_skill_27", nil)
	_ENV, _ENV, i18n("jinn_skill_27", nil).lv = i18n("jinn_skill_27", nil)
	i18n("jinn_skill_27", nil).lv, i18n("jinn_skill_27", nil).color = i18n("jinn_skill_27", nil)
	fields.Text_maxLv:setString(i18n_html("jinn_skill_28", i18n("jinn_skill_27", nil)))
	local skillGroup = magicLampSkillRead.getSkillSkillGroup(data.skillType)
	local skill = skillGroup[data.classLv + 1]
	if skill ~= 0 then
		local buffDes = magicLampSkillRead.getSkillBuffDes(skill)
		fields.Text_buff:setString(buffDes)
	else
		local firstClassLv = magicLampSkillRead.getFirstBuffClassLv(skillGroup)
		if firstClassLv then
			fields.Text_buff:setString(i18n("jinn_skill_75"))
		else
			self.fields.Com_arrow3:setVisible(false)
			fields.Text_buff:setString(i18n("jinn_skill_76"))
		end
	end
end
function MagicLampSkillAdvancePanel:onSkillItemRenderer(index, obj)
	index = index + 1
	local cfg = self.needSkill[index]
	if not obj.fields then
		obj.fields = fguiHelper.get_fields(obj)
		obj:addClickListener(handler(self, self.onClickBtnAdd))
	end
	obj:setTag(index)
	local Com_skill = obj.fields.Com_skill
	if cfg.type == gJinnSkillNeedSkillType.SKILLTYPE then
		_ENV = handler(self, self.onClickBtnAdd)
		handler(self, self.onClickBtnAdd).skillType = self.data.skillType
		handler(self, self.onClickBtnAdd).classLv = cfg.classLv
		Com_skill:initNeedSkillData(handler(self, self.onClickBtnAdd))
	elseif cfg.type == gJinnSkillNeedSkillType.QUALITY then
		_ENV = handler(self, self.onClickBtnAdd)
		handler(self, self.onClickBtnAdd).quality = cfg.value
		handler(self, self.onClickBtnAdd).classLv = cfg.classLv
		Com_skill:initNeedSkillData(handler(self, self.onClickBtnAdd))
	end
	if not self.chooseList[index] then
		local _ENV, chooseList = self.chooseList[index], self.chooseList[index]
	end
	local count = #chooseList
	local total = cfg.count
	_ENV = handler(self, self.onClickBtnAdd)
	handler(self, self.onClickBtnAdd).member = count
	handler(self, self.onClickBtnAdd).total = total
	obj.fields.Text_count:setString(i18n("common_text_155", handler(self, self.onClickBtnAdd)))
	local enough = count >= total
	local textColor = enough and cc.c3b(255, 223, 104) or cc.c3b(255, 0, 0)
	obj.fields.Text_count:setColor(textColor)
	obj.fields.Image_add:setVisible(not enough)
	Com_skill:showDark(not enough)
	local mark = false
	for __, skillID in ipairs(chooseList) do
		local data = magicLampSkillCtrl:getSkillData(skillID)
		if 1 < data.lv then
			mark = true
			break
		end
	end
	obj.fields.Com_mark:setVisible(mark)
end
function MagicLampSkillAdvancePanel:onClickBtnAdd(EventContext)
	SoraDPlaySound()
	local sender = EventContext:getSender()
	local index = sender:getTag()
	local cfg = self.needSkill[index]
	local _ENV, otherList
	for k, v in pairs(self.chooseList) do
		if k ~= index then
			table.insertto(otherList, v)
		end
	end
	table.insert(otherList, self.data.id)
	_ENV = table.insert
	table.insert.classLv = cfg.classLv
	table.insert.needCount = cfg.count
	table.insert.chooseHandle = handler(self, self.onHandleChooseBack)
	table.insert.index = index
	table.insert.chooseList = self.chooseList[index]
	local table.insert.otherList, param = otherList, table.insert
	if cfg.type == gJinnSkillNeedSkillType.SKILLTYPE then
		param.skillType = self.data.skillType
		uiManager:show("MagicLampSkillChoose", param)
	elseif cfg.type == gJinnSkillNeedSkillType.QUALITY then
		param.quality = cfg.value
		uiManager:show("MagicLampSkillChoose", param)
	end
end
function MagicLampSkillAdvancePanel:onHandleChooseBack(index, chooseList)
	if tolua.isnull(self) then
		return
	end
	dump(chooseList, "==onHandleChooseBack==")
	self.chooseList[index] = chooseList
	self.fields.List_skill:setNumItems(#self.needSkill)
	local enough = self:checkNeedSkillEnough()
	self.fields.Button_upgrade:setBright(enough)
	self:updateTextReturn()
end
function MagicLampSkillAdvancePanel:checkNeedSkillEnough(...)
	local enough = true
	for index, cfg in ipairs(self.needSkill) do
		if not self.chooseList[index] then
			_ENV = self.chooseList[index]
		end
		local count = #self.chooseList[index]
		if count < cfg.count then
			enough = false
			break
		end
	end
	return enough
end
function MagicLampSkillAdvancePanel:updateTextReturn(...)
	local _ENV, costList
	for k, v in pairs(self.chooseList) do
		table.insertto(costList, v)
	end
	local returnStr = i18n("jinn_skill_29")
	local returnNum, returnMap = magicLampSkillRead.getLvReturnNum(costList)
	if 0 < returnNum then
		local _ENV, itemStr
		for itemID, count in pairs(returnMap) do
			if 0 < count then
				local itemName = publicRead.getName(itemID)
				table.insert(itemStr, string.format("%s×%d", itemName, count))
			end
		end
		_ENV = nil
		;(nil).item = table.concat(itemStr, ",")
		returnStr = returnStr .. "\n" .. i18n("jinn_skill_63", nil)
	end
	self.fields.Text_return:setString(returnStr)
	self.fields.Com_mark:setVisible(0 < returnNum)
end
return MagicLampSkillAdvancePanel
