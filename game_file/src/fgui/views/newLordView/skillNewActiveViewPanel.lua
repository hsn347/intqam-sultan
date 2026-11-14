local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local godArmsCtrl = SoraDGetCtrl("godArmsCtrl")
local skillDes = include("lordSkillDesRead")
local buffCtrl = SoraDGetCtrl("buffCtrl")
local lordSkillModuleAPI = include("lordSkillModuleAPI")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local equipDesRead = include("equipDesRead")
local artifactRuneRead = include("artifactRuneRead")
local combinationCtrl = SoraDGetCtrl("combinationCtrl")
local heroComboSkillCtrl = SoraDGetCtrl("heroComboSkillCtrl")
local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
_ENV = "godArmsRuneCtrl"
;("godArmsRuneCtrl").BEUSE = 1
;("godArmsRuneCtrl").UNUSE = 2
;("godArmsRuneCtrl").ACTIVE = 3
;("godArmsRuneCtrl").LOOK = 4
;("godArmsRuneCtrl").ACTVIP = 5
local ("godArmsRuneCtrl").HIDEN, btnStatusDef = 6, "godArmsRuneCtrl"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local skillNewActiveViewPanel = class("skillNewActiveViewPanel", baseFguiPanel)
function skillNewActiveViewPanel:ctor(...)
	skillNewActiveViewPanel.super.ctor(self, ...)
	print("skillNewActiveViewPanel:ctor", self.viewName)
end
function skillNewActiveViewPanel:onInit()
	print("=======skillNewActiveViewPanel:onInit")
	self.resetToolID = 501301
	self.status = btnStatusDef.BEUSE
	self.tabsetArray, _ENV, self.tag = btnStatusDef.BEUSE, btnStatusDef.BEUSE, 1
	self.setID = tonumber(lordSkillModuleAPI:getActiveSetID()) or 1
	self.curSkillIndex = 1
	self.fields.Panel_bg:setString(i18n("common_text_722"))
	self.skillDataList, _ENV, self.Text_notice = SoraDCreateTimerLabel(self, self.fields.Text_notice), SoraDCreateTimerLabel(self, self.fields.Text_notice), SoraDCreateTimerLabel(self, self.fields.Text_notice)
	self.fields.List_skill:setItemRenderer(handler(self, self.onSkillRenderer))
	self.fields.List_skill:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	self.tableArmsSkill, _ENV = self.fields.List_skill.addEventListener, self.fields.List_skill.addEventListener
	self.curArmsIndex = 1
	self.fields.List_arms:setItemRenderer(handler(self, self.onArmsRenderer))
	self.fields.List_arms:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onArmsClickItem))
	self.heroSkillDataList, _ENV, self.curHeroSkillIndex = self.fields.List_arms.addEventListener, self.fields.List_arms.addEventListener, 1
	self.fields.List_heroSkill:setItemRenderer(handler(self, self.onHeroSkillRenderer))
	self.fields.List_heroSkill:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onHeroClickItem))
	self.fields.List_cGroup:setItemRenderer(handler(self, self.onCGroupRenderer))
	exaltedPrivilegeCtrl, self.items, _ENV = self.fields.List_cGroup.setItemRenderer, self.fields.List_cGroup.setItemRenderer, self.fields.List_cGroup.setItemRenderer
	self.fields.List_cGroup.setItemRenderer[1] = 1
	self.fields.List_cGroup.setItemRenderer[2] = 2
	local self.fields.List_cGroup.setItemRenderer[3], values = 3, self.fields.List_cGroup.setItemRenderer
	if exaltedPrivilegeCtrl:checkPrivilege(gExaltedPrivilegeType.LORD_SKILL_SET) then
		_UPVALUE6_ = exaltedPrivilegeCtrl:checkPrivilege(gExaltedPrivilegeType.LORD_SKILL_SET)
		values, exaltedPrivilegeCtrl:checkPrivilege(gExaltedPrivilegeType.LORD_SKILL_SET)[1] = exaltedPrivilegeCtrl:checkPrivilege(gExaltedPrivilegeType.LORD_SKILL_SET), 1
		values, exaltedPrivilegeCtrl:checkPrivilege(gExaltedPrivilegeType.LORD_SKILL_SET)[2] = exaltedPrivilegeCtrl:checkPrivilege(gExaltedPrivilegeType.LORD_SKILL_SET), 2
		values, exaltedPrivilegeCtrl:checkPrivilege(gExaltedPrivilegeType.LORD_SKILL_SET)[3] = exaltedPrivilegeCtrl:checkPrivilege(gExaltedPrivilegeType.LORD_SKILL_SET), 3
		values, exaltedPrivilegeCtrl:checkPrivilege(gExaltedPrivilegeType.LORD_SKILL_SET)[4] = exaltedPrivilegeCtrl:checkPrivilege(gExaltedPrivilegeType.LORD_SKILL_SET), 4
		values, exaltedPrivilegeCtrl:checkPrivilege(gExaltedPrivilegeType.LORD_SKILL_SET)[5] = exaltedPrivilegeCtrl:checkPrivilege(gExaltedPrivilegeType.LORD_SKILL_SET), 5
		values, exaltedPrivilegeCtrl:checkPrivilege(gExaltedPrivilegeType.LORD_SKILL_SET)[6] = exaltedPrivilegeCtrl:checkPrivilege(gExaltedPrivilegeType.LORD_SKILL_SET), 6
	end
	for k, v in ipairs(values) do
		self.items[k] = combinationCtrl:getSetName(combinationCtrl.COMBINATION_TYPE.LORDSKILL, v) or ""
	end
	local dropdown = self.fields.ComboBox_sel:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	_ENV = 4
	;(4).items = self.items
	;(4).values = values
	;(4).changedCallback = handler(self, self.onComboBoxClick)
	self:setComboBox(self.fields.ComboBox_sel, 4)
	self.fields.ComboBox_sel:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxList:setHeight(#values * 40)
		if self.comboBoxList:getChildrenCount() < #values then
			return
		end
		for i, v in ipairs(values) do
			local single = self.comboBoxList:getChildAt(i - 1)
			single:getChildByName("lock"):setVisible(not self:isSetUnlock(i))
		end
		self.comboBoxList:setSelectedIndex(self.setID - 1)
	end)
	self.fields.ComboBox_sel:fixChildrenPos()
	self.fields.tips_txt:setString(i18n("lordskill_text_13"))
	self.fields.tips_txt:setVisible(false)
	self.fields.Label_content:setAlign(1)
	self.fields.Btn_go:addClickListener(handler(self, self.btnGoClick))
	self.fields.Btn_active:addClickListener(handler(self, self.btnGoClick))
	self.fields.Btn_touch:addClickListener(handler(self, self.btnTouchClick))
	self.fields.Btn_touch:setVisible(false)
	self.fields.Com_group:setVisible(false)
end
function skillNewActiveViewPanel:onComboBoxClick()
	SoraDPlaySound()
	local setID = tonumber(self.fields.ComboBox_sel:getValue())
	if not self:isSetUnlock(setID) then
		combinationCtrl:checkSetUnLock(combinationCtrl.COMBINATION_TYPE.LORDSKILL, setID, true)
		self.fields.ComboBox_sel:setTitle(self.items[self.setID])
		return
	end
	self.setID = setID
	self:setSkillList(self.setID)
	self:setSkillInfo()
	self:updateBtnAndNotice()
end
function skillNewActiveViewPanel:isSetUnlock(index)
	return combinationCtrl:checkSetUnLock(combinationCtrl.COMBINATION_TYPE.LORDSKILL, index, false)
end
function skillNewActiveViewPanel:onClickItem()
	SoraDPlaySound()
	local index = self.fields.List_skill:getSelectedIndex() + 1
	self.curSkillIndex = index
	self:setSkillInfo()
	self:updateBtnAndNotice()
end
function skillNewActiveViewPanel:onHeroClickItem()
	SoraDPlaySound()
	local index = self.fields.List_heroSkill:getSelectedIndex() + 1
	self.curHeroSkillIndex = index
	self:setSkillInfo()
	self:updateBtnAndNotice()
end
function skillNewActiveViewPanel:onArmsClickItem()
	SoraDPlaySound()
	local index = self.fields.List_arms:getSelectedIndex() + 1
	self.curArmsIndex = index
	self:setSkillInfo()
	self:updateBtnAndNotice()
end
function skillNewActiveViewPanel:onSkillRenderer(index, obj)
	obj:initData(self.skillDataList[index + 1])
	obj:setSelected(self.curSkillIndex == index + 1)
end
function skillNewActiveViewPanel:onHeroSkillRenderer(index, obj)
	obj:initDataEX(self.heroSkillDataList[index + 1])
	obj:setSelected(self.curHeroSkillIndex == index + 1)
end
function skillNewActiveViewPanel:onArmsRenderer(index, obj)
	obj:initData(self.tableArmsSkill[index + 1])
	obj:setSelected(self.curArmsIndex == index + 1)
end
function skillNewActiveViewPanel:onCGroupRenderer(index, obj)
	obj:initData(index + 1, self.isFromUsing)
end
function skillNewActiveViewPanel:setSkillList(setID)
	self.skillDataList, lordSkillModuleAPI, self.setID = setID or lordSkillModuleAPI:getActiveSetID(), setID or lordSkillModuleAPI:getActiveSetID(), setID or lordSkillModuleAPI:getActiveSetID()
	local useSkillList = lordSkillModuleAPI:getUseSkillList()
	for k, v in ipairs(useSkillList) do
		self.skillDataList[k] = lordSkillModuleAPI:getSkillDetail(self.setID, v.skillID)
	end
	table.sort(self.skillDataList, function(a, b)
		if a.isOpened and not b.isOpened then
			return true
		elseif not a.isOpened and b.isOpened then
			return false
		else
			return tonumber(a.skillID) > tonumber(b.skillID)
		end
	end)
	self.curSkillIndex = 1
	if self.skillID then
		for k, v in ipairs(self.skillDataList) do
			if tonumber(v.skillID) == tonumber(self.skillID) then
				self.curSkillIndex = k
				break
			end
		end
		self.skillID = nil
	end
	self.fields.List_skill:setNumItems(#self.skillDataList)
end
function skillNewActiveViewPanel:setSkillInfo()
	if self.tag == 1 then
		self.curSkill = self.skillDataList[self.curSkillIndex]
		self.fields.Text_curSkill:setString(skillDes.getName(self.curSkill.skillID))
		local des = skillDes.getDes(self.curSkill.skillID)
		if self.curSkill.skillID == lordSkillIDDefine.siegeLore or self.curSkill.skillID == lordSkillIDDefine.killBarrier then
			local curSkillDetail = lordSkillModuleAPI:getSkillDetail(self.setID, self.curSkill.skillID)
			curSkillDetail.currentLevel = math.max(curSkillDetail.currentLevel or 1, 1)
			local buffValue = lordSkillModuleAPI:getBuffInfoText(tonumber(lordSkillModuleAPI:getActiveSetID()), self.curSkill.skillID, curSkillDetail.currentLevel)
			des = skillDes.getHaveNumDes(self.curSkill.skillID, buffValue / 10)
		end
		self.fields.Label_content:setString(des)
	elseif self.tag == 2 then
		self.curSkill = self.tableArmsSkill[self.curArmsIndex]
		if self.curSkill then
			self.fields.Text_curSkill:setString(i18n(self.curSkill.name))
			self.fields.Label_content:setString(i18n(self.curSkill.des))
		end
	elseif self.tag == 4 then
		self.curSkill = self.heroSkillDataList[self.curHeroSkillIndex]
		local skillInfo = heroltCtrl:getCombosSkillInfo(self.curSkill.skillID)
		self.fields.Text_curSkill:setString(i18n(skillInfo.skillName))
		self.fields.Label_content:setString(heroCtrl:getComboSkillDes(self.curSkill.skillID))
	end
end
function skillNewActiveViewPanel:updateBtnAndNotice()
	self.fields.tips_txt:setVisible(false)
	self.Text_notice:endTime()
	self.status = btnStatusDef.ACTIVE
	local isOK, needVipLv = lordSkillModuleAPI:isSkillSetUnlock(tostring(self.setID))
	if self.tag == 4 then
		local cfg = heroltCtrl:getDressSerSkilCfg(self.curSkill.skillID)
		if not heroCtrl:getHeroInfoByID(cfg.heroID) or cfg.lieutenant == 0 or not heroCtrl:getHeroInfoByID(cfg.lieutenant) then
			btnStatusDef = tostring(self.setID)
			tostring(self.setID).name1 = i18n(heroltCtrl.getHeroName(cfg.heroID))
			tostring(self.setID).name2 = i18n(heroltCtrl.getHeroName(cfg.lieutenant))
			self.Text_notice:setString(i18n("lieutenant_text_25", tostring(self.setID)))
			self.status = btnStatusDef.LOOK
		else
			local isInCD = heroComboSkillCtrl:isInCD(self.curSkill.skillID)
			local remainTime = heroComboSkillCtrl:getSkillRemainTime(self.curSkill.skillID)
			if isInCD then
				self.Text_notice:setString(i18n("common_text_4049"))
				self.status = btnStatusDef.UNUSE
			elseif 0 < remainTime then
				self.Text_notice:setTimeLast(function(time, timeNum)
					if timeNum <= 0 then
						self:refreshView()
					end
					self = nil
					;(nil).time = time
					return i18n("lieutenant_text_24", nil)
				end)
				self.Text_notice:beginTime(remainTime)
				self.status = btnStatusDef.UNUSE
			else
				self.status = btnStatusDef.BEUSE
				if self:getSkillCD(self.curSkill.skillID) > 0 then
					btnStatusDef = i18n("common_text_4049")
					i18n("common_text_4049").time = SoraDConvertSecondToString(self:getSkillCD(self.curSkill.skillID))
					self.Text_notice:setString(i18n("common_text_725", i18n("common_text_4049")))
				else
					self.Text_notice:setString("")
				end
			end
		end
	elseif tonumber(self.setID) == tonumber(lordSkillModuleAPI:getActiveSetID()) or self.tag == 2 then
		self.Text_notice:setVisible(true)
		if isOK or self.tag == 2 then
			local isOpened = self.curSkill and (self.curSkill.isOpened or self.curSkill.isActive) or false
			if not isOpened then
				self.Text_notice:setString(i18n("common_text_723"))
				self.status = btnStatusDef.LOOK
			else
				local buffid = skillDes.getBuffID(self.curSkill.skillID)
				local isInCD, cdTime = lordSkillModuleAPI:skillInCD(self.curSkill.skillID)
				if self.tag == 2 then
					buffid = self.curSkill.buffId[1]
					isInCD, cdTime = godArmsCtrl:skillInCD(self.curSkill.skillID, self.curSkill.skillCD)
				end
				local isOpen, buff = buffCtrl:isBuffOpen(buffid)
				local isNotTimeQueue = buffCtrl:getRemainTimeByBuffID(buffid)
				if isOpen then
					self.status = btnStatusDef.UNUSE
					if isNotTimeQueue then
						self.Text_notice:setString(i18n("common_text_4048"))
					else
						self.Text_notice:setString(i18n("common_text_1765"))
					end
				elseif isInCD then
					self.Text_notice:setString(i18n("common_text_4049"))
					self.status = btnStatusDef.UNUSE
				else
					self.status = btnStatusDef.BEUSE
					btnStatusDef = i18n("common_text_4049")
					i18n("common_text_4049").time = SoraDConvertSecondToString(self:getSkillCD(self.curSkill.skillID))
					self.Text_notice:setString(i18n("common_text_725", i18n("common_text_4049")))
				end
			end
			if self.curSkill and tonumber(self.curSkill.skillID) == lordSkillIDDefine.duel then
				self.status = btnStatusDef.HIDEN
				self.fields.tips_txt:setVisible(true)
			end
		else
			self.status = btnStatusDef.ACTVIP
		end
	else
		self.Text_notice:setVisible(false)
	end
	self:setBtnStatus()
end
function skillNewActiveViewPanel:setBtnStatus()
	if self.tag == 3 then
		self.fields.Btn_go:setVisible(false)
		self.fields.Btn_active:setVisible(false)
		return
	end
	self.fields.Btn_go:setVisible(true)
	self.fields.Btn_active:setVisible(false)
	self.fields.Btn_go:setEnabled(true)
	if self.status == btnStatusDef.BEUSE then
		if self.tag == 4 then
			btnStatusDef = nil
			;(nil).num = heroComboSkillCtrl:getLeftUseNum(self.curSkill.skillID)
			self.fields.Btn_go:setString(i18n("common_text_314") .. i18n("lieutenant_text_23", nil))
		else
			self.fields.Btn_go:setString(i18n("common_text_314"))
		end
	elseif self.status == btnStatusDef.UNUSE then
		self.fields.Btn_go:setString(i18n("common_text_314"))
		self.fields.Btn_go:setEnabled(false)
	elseif self.status == btnStatusDef.ACTIVE then
		if self.tag == 1 then
			self.fields.Btn_go:setVisible(false)
			self.fields.Btn_active:setVisible(true)
			self.fields.Btn_active:setString(i18n("common_btn_05"))
			local count = backpackCtrl:getItemCount(self.resetToolID)
			if 0 < count then
				self.fields.Btn_active:setCostIcon(publicRead.getIcon(self.resetToolID))
				self.fields.Btn_active:setCostTitle("1")
			else
				self.fields.Btn_active:setCostIcon(publicRead.getIcon(gIDDef.GOLD))
				self.fields.Btn_active:setCostTitle(gConstValue.LORD_RESET_SKILL_POINT)
			end
		elseif self.tag == 4 then
			self.fields.Btn_go:setString(i18n("lieutenant_text_15"))
		end
	elseif self.status == btnStatusDef.LOOK then
		self.fields.Btn_go:setString(i18n("common_text_724"))
	elseif self.status == btnStatusDef.ACTVIP then
		local isOK, needVipLv = lordSkillModuleAPI:isSkillSetUnlock(tostring(self.setID))
		btnStatusDef = tostring(self.setID)
		tostring(self.setID).vip = needVipLv
		self.fields.Btn_go:setString(i18n("common_text_1771", tostring(self.setID)))
	elseif self.status == btnStatusDef.HIDEN then
		self.fields.Btn_go:setVisible(false)
		self.fields.Btn_active:setVisible(false)
	end
end
function skillNewActiveViewPanel:getSkillCD(skillID)
	if self.tag == 1 or self.tag == 3 then
		local skillCDData = lordSkillModuleAPI:getSkillCDData(skillID)
		return skillCDData and skillCDData.defaultCD or 0
	elseif self.tag == 4 then
		local skillData = heroltCtrl:getCombosSkillInfo(skillID)
		return skillData and skillData.skillCD or 0
	else
		for i, v in ipairs(self.tableArmsSkill) do
			if v.skillID == skillID then
				return v.skillCD
			end
		end
		return 0
	end
end
function skillNewActiveViewPanel:onShow()
	print("=======skillNewActiveViewPanel:onShow")
	SoraDPlaySound("innercontrol", 6)
	_ENV, _ENV, self.skillID = "innercontrol", self.param and self.param.skillID, self.param and self.param.skillID
	;("innercontrol").title = i18n("common_text_775")
	self.tabsetArray, (self.param and self.param.skillID)[1], ("innercontrol").tag = self.param and self.param.skillID, "innercontrol", 1
	local tableArmsSkill = godArmsCtrl:getSkillList()
	if commonCheck.ARTIFACT and SoraDGetCastleLv() >= include("funUnlockRead").getUnlockLevel(gFunBuildKey.ARTIFACT) and tableArmsSkill and next(tableArmsSkill) then
		_ENV = gFunBuildKey.ARTIFACT
		gFunBuildKey.ARTIFACT.title = i18n("artifact_title_01")
		gFunBuildKey.ARTIFACT.tag = 2
		table.insert(self.tabsetArray, gFunBuildKey.ARTIFACT)
	end
	if exaltedPrivilegeCtrl:checkPrivilege(gExaltedPrivilegeType.ATTR_SET) then
		_ENV = gExaltedPrivilegeType.ATTR_SET
		gExaltedPrivilegeType.ATTR_SET.title = i18n("privilege_btn_05")
		gExaltedPrivilegeType.ATTR_SET.tag = 3
		table.insert(self.tabsetArray, gExaltedPrivilegeType.ATTR_SET)
		combinationCtrl:reqCombinatioInitData()
	end
	local allSkill = heroltCtrl:getAllHeroCombosSkill()
	if commonCheck.HERO_COMBOS_SKILL and next(allSkill) then
		_ENV = i18n("privilege_btn_05")
		i18n("privilege_btn_05").title = i18n("common_text_4870")
		i18n("privilege_btn_05").tag = 4
		table.insert(self.tabsetArray, (i18n("privilege_btn_05")))
		heroComboSkillCtrl:sendReqInitDataMsg()
	end
	self.tabsetArray = SoraDFIsRA() and table.reverse(self.tabsetArray) or self.tabsetArray
	_ENV = i18n("privilege_btn_05")
	i18n("privilege_btn_05").defaultClick = self.tag
	i18n("privilege_btn_05").tabsetArray = self.tabsetArray
	i18n("privilege_btn_05").callback = handler(self, self.onClickTab)
	self.fields.com_Tab:initView((i18n("privilege_btn_05")))
end
function skillNewActiveViewPanel:onClickTab(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self:refreshView()
end
function skillNewActiveViewPanel:refreshView(target, data)
	SoraDCloseLoading(self)
	if self.tag == 1 then
		self.fields.ComboBox_sel:setTitle(self.items[self.setID])
		self:setSkillList(self.setID)
	elseif self.tag == 2 then
		self.tableArmsSkill = godArmsCtrl:getSkillList()
		self.fields.List_arms:setNumItems(#self.tableArmsSkill)
	elseif self.tag == 3 then
		self.isFromUsing = data and data.isUsing
		local attrSetCount = exaltedPrivilegeCtrl:checkPrivilege(gExaltedPrivilegeType.ATTR_SET) or 0
		self.fields.List_cGroup:setNumItems(attrSetCount)
		self.tableArmsSkill = godArmsCtrl:getSkillList()
		self.fields.List_arms:setNumItems(#self.tableArmsSkill)
	elseif self.tag == 4 then
		self.heroSkillDataList = heroltCtrl:getAllHeroCombosSkill()
		self.fields.List_heroSkill:setNumItems(#self.heroSkillDataList)
	end
	self:setSkillInfo()
	self:updateBtnAndNotice()
end
function skillNewActiveViewPanel:skillCanUse()
	local ret = true
	if tonumber(self.curSkill.skillID) == lordSkillIDDefine.trapAction then
		if worldMapDefine.isInWar() or worldMapDefine.isInKingdomBattle() then
			SoraDShowMsgTip(i18n("common_text_3302"))
			return false
		end
		local buildCell = cityCtrl:getBuildCell(BUILDID.FORTRESS, 0)
		if nil == buildCell then
			_ENV = i18n("common_text_3302")
			i18n("common_text_3302").name = i18n("buildDes_name_120")
			SoraDShowMsgTip(i18n("lordskill_text_08", i18n("common_text_3302")))
			return false
		end
		local armyCtrl = SoraDGetCtrl("armyCtrl")
		local armyLogic = include("armyLogic")
		local trapCount = armyCtrl:getTrapTotalCount()
		local trapMax = armyLogic.getTotalTrapCapacity().total
		local curActiveSetID = lordSkillModuleAPI:getActiveSetID()
		local tbResult = lordSkillModuleAPI:getSkillBuff(curActiveSetID, self.curSkill.skillID, 1)
		local numValue = tbResult.value
		if trapCount >= trapMax then
			SoraDShowMsgTip(i18n("common_text_2092"), skillDes.getIcon(self.curSkill.skillID, true))
			ret = false
		elseif trapMax < trapCount + numValue then
			local showMsg = i18n("lordskill_text_09")
			SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					lordSkillModuleAPI:useSkill(self.curSkill.skillID)
					self:close()
				end
			end)
			ret = false
		end
	elseif tonumber(self.curSkill.skillID) == lordSkillIDDefine.rescue then
		local haveBuff = buffCtrl:queryCityBuff(gBuffEffect.SALVATION)
		if haveBuff then
			SoraDShowMsgBox(i18n("common_text_3167"), i18n("common_text_204"), nil, function(callback)
				if callback == MSGBOX_CALLBACK_YES then
					lordSkillModuleAPI:useSkill(self.curSkill.skillID)
				end
			end)
			ret = false
		end
	elseif tonumber(self.curSkill.skillID) == lordSkillIDDefine.duel then
		ret = false
	elseif tonumber(self.curSkill.skillID) == lordSkillIDDefine.skill_11042 and not include("pyramidWarltCtrl").checkPwXianXiaSai() then
		return false
	end
	return ret
end
function skillNewActiveViewPanel:btnTouchClick()
	self.fields.Btn_touch:setVisible(false)
	self.fields.Com_group:setVisible(false)
end
function skillNewActiveViewPanel:openGroupSet(target, data)
	if data.isSet then
		self.fields.Btn_touch:setVisible(false)
		self.fields.Com_group:setVisible(false)
	else
		self.fields.Btn_touch:setVisible(true)
		self.fields.Com_group:setVisible(true)
		self.fields.Com_group:initData(data.idx, data.index, data.weaponID, data.isFromUsing, data.ctype, data.otherData)
		local pos = self.view:globalToLocal(cc.p(data.pos.x, data.pos.y))
		local newPos = cc.p(pos.x - self.fields.Com_group:getWidth() / 2, pos.y + 50)
		if newPos.y > display.height / 2 then
			newPos.y = pos.y - self.fields.Com_group:getHeight() - 50
		end
		self.fields.Com_group:setPosition(newPos)
	end
end
function skillNewActiveViewPanel:btnGoClick()
	SoraDPlaySound()
	if self.status == btnStatusDef.BEUSE then
		if self:skillCanUse() then
			if self.tag == 1 then
				local buffid = 0
				local isOpen = false
				local frontBuffName = ""
				local afterBuffName = ""
				if self.curSkill.skillID == lordSkillIDDefine.siegeLore then
					if worldMapDefine.isInPyramid() then
						SoraDShowMsgTip(i18n("common_text_4706"))
						return
					end
					buffid = skillDes.getBuffID(lordSkillIDDefine.killBarrier)
					isOpen = buffCtrl:isBuffOpen(buffid)
					frontBuffName = skillDes.getName(lordSkillIDDefine.siegeLore)
					afterBuffName = skillDes.getName(lordSkillIDDefine.killBarrier)
				elseif self.curSkill.skillID == lordSkillIDDefine.killBarrier then
					buffid = skillDes.getBuffID(lordSkillIDDefine.siegeLore)
					isOpen = buffCtrl:isBuffOpen(buffid)
					frontBuffName = skillDes.getName(lordSkillIDDefine.killBarrier)
					afterBuffName = skillDes.getName(lordSkillIDDefine.siegeLore)
				end
				if isOpen then
					_ENV = i18n("common_text_4706")
					i18n("common_text_4706").frontBuff = afterBuffName
					i18n("common_text_4706").afterBuff = frontBuffName
					SoraDShowMsgBox(i18n("lord_text_01", i18n("common_text_4706")), i18n("common_text_054"), i18n("common_text_185"), function(type)
						if type == MSGBOX_CALLBACK_YES then
							lordSkillModuleAPI:useSkill(self.curSkill.skillID)
							self:close()
						end
					end)
				else
					lordSkillModuleAPI:useSkill(self.curSkill.skillID)
					self:close()
				end
			elseif self.tag == 2 and self.curSkill and self.curSkill then
				godArmsCtrl:reqUseSkill(self.curSkill.weaponID, self.curSkill.skillID)
			elseif self.tag == 4 and heroComboSkillCtrl:checkCanUseSkill(self.curSkill.skillID, self.curSkill.heroID, self.curSkill.dressID) then
				heroComboSkillCtrl:reqHeroComboSkillUse(self.curSkill.skillGroup)
			end
		end
	elseif self.status == btnStatusDef.ACTIVE then
		if self.tag == 4 then
			_ENV = self.curSkill.heroID
			self.curSkill.heroID.heroID = self.curSkill.heroID
			self.curSkill.heroID.heroClass = heroltCtrl.getHeroType(self.curSkill.heroID)
			uiManager:show("HeroSkin", self.curSkill.heroID)
		else
			local setData = lordSkillModuleAPI:getSkillSetData(self.setID)
			local showMsg = 0 < setData.skillPoints and i18n("lordskill_text_01") or i18n("lordskill_text_02")
			function _ENV(type)
				if type == MSGBOX_CALLBACK_YES then
					lordSkillModuleAPI:useSkill(self.curSkill.skillID)
					self:close()
				end
			end
			;(function(type)
				if type == MSGBOX_CALLBACK_YES then
					lordSkillModuleAPI:useSkill(self.curSkill.skillID)
					self:close()
				end
			end).itemID = self.resetToolID
			SoraDShowBuyBox(showMsg, gConstValue.LORD_RESET_SKILL_POINT, i18n("common_text_054"), function(event)
				if event == MSGBOX_CALLBACK_YES then
					lordSkillModuleAPI:switchSkillSet(tostring(self.setID))
					SoraDShowLoading(self)
				end
			end, true, function(type)
				if type == MSGBOX_CALLBACK_YES then
					lordSkillModuleAPI:useSkill(self.curSkill.skillID)
					self:close()
				end
			end)
		end
	elseif self.status == btnStatusDef.LOOK then
		if self.tag == 1 then
			_ENV = showMsg
			showMsg.skillID = self.curSkill.skillID
			uiManager:show("skillView", showMsg)
		elseif self.tag == 2 then
			_ENV = showMsg
			showMsg.index = self.curSkill.ID
			uiManager:show("ArtifactView", showMsg)
		elseif self.tag == 4 then
			local cfg = heroltCtrl:getDressSerSkilCfg(self.curSkill.skillID)
			local heroID = cfg.heroID
			if not heroCtrl:getHeroInfoByID(cfg.heroID) then
				heroID = cfg.heroID
			elseif cfg.lieutenant ~= 0 and not heroCtrl:getHeroInfoByID(cfg.lieutenant) then
				heroID = cfg.lieutenant
			end
			local panel = uiManager:show("newHeroListView").view
			panel:jumpToUnlockHero(heroID)
		end
	elseif self.status == btnStatusDef.ACTVIP then
		uiManager:show("vipCenterView")
		self:close()
	end
end
return skillNewActiveViewPanel
