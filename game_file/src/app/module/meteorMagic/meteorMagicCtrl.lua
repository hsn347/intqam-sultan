local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local meteorMagicCtrl = class("meteorMagicCtrl", GameModule)
local meteorMagicRead = include("meteorMagicRead")
function meteorMagicCtrl:ctor(properties)
	meteorMagicCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NEBULA_REGION_ACTIVITY
end
function meteorMagicCtrl:EnterGame()
	print("meteorMagicCtrl:EnterGame")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	msgCtrl.register(gCmd.CMD_METEOR_MAGIC_MODULE, gCmd.REQ_METEOR_MAGIC_INIT, handler(self, self.sendReqInitRsp))
	msgCtrl.register(gCmd.CMD_METEOR_MAGIC_MODULE, gCmd.REQ_METEOR_MAGIC_USE_ITEM, handler(self, self.useItemRsp))
	msgCtrl.register(gCmd.CMD_METEOR_MAGIC_MODULE, gCmd.REQ_METEOR_MAGIC_OPEN_LIGHT, handler(self, self.openLightRsp))
	msgCtrl.register(gCmd.CMD_METEOR_MAGIC_MODULE, gCmd.REQ_METEOR_MAGIC_CLOSE_LIGHT, handler(self, self.closeLightRsp))
	msgCtrl.register(gCmd.CMD_METEOR_MAGIC_MODULE, gCmd.REQ_METEOR_MAGIC_OPEN_ACTIVATE, handler(self, self.openActiveRsp))
	msgCtrl.register(gCmd.CMD_METEOR_MAGIC_MODULE, gCmd.REQ_METEOR_MAGIC_CLOSE_ACTIVATE, handler(self, self.closeActiveRsp))
	msgCtrl.register(gCmd.CMD_METEOR_MAGIC_MODULE, gCmd.REQ_METEOR_MAGIC_CHANGE_PROJECT, handler(self, self.changeProjectRsp))
	msgCtrl.register(gCmd.CMD_METEOR_MAGIC_MODULE, gCmd.REQ_METEOR_MAGIC_MODIFY_NAME, handler(self, self.modifyNameRsp))
	msgCtrl.register(gCmd.CMD_METEOR_MAGIC_MODULE, gCmd.REQ_METEOR_MAGIC_USE_SKILL, handler(self, self.useSkillRsp))
	msgCtrl.register(gCmd.CMD_METEOR_MAGIC_MODULE, gCmd.REQ_METEOR_MAGIC_OPEN_LIGHT_2, handler(self, self.openLightsRsp))
	self:resetData()
	self:registerNotify()
	self:sendDataMsg()
end
function meteorMagicCtrl:judgeClose(target, data)
	if data.id == self.activityID and not clientEventMgr.judgeIsOpen(self.activityID) then
		self:resetData()
	end
end
function meteorMagicCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.METEOR_MAGIC, handler(self, self.notifyHandler))
end
function meteorMagicCtrl:notifyHandler(event)
	dump(event.data, "meteorMagicCtrl:notifyHandler", 10)
	for _, content in ipairs(event.data) do
		self:setData(content)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_METEOR_MAGIC"
		self.subMsg = "init"
		SoraDSendMessage(self)
	end
end
function meteorMagicCtrl:initClientData(data)
	dump(data, "meteorMagicCtrl:initClientData", 10)
	if data then
		self:setData(data)
	end
end
function meteorMagicCtrl:Logout()
	self:resetData()
	meteorMagicCtrl.super.Logout(self)
end
function meteorMagicCtrl:resetData()
	self.data = nil
	self.buffList = nil
	self.skillList = nil
end
function meteorMagicCtrl:setData(data)
	self.data = data.initData
	self.buffList = self:getBuffListByProjectID(self:getCurProjectID())
	self.skillList, self.skillBuffList = self:getSkillList()
end
function meteorMagicCtrl:sendDataMsg()
	print("meteorMagicCtrl:sendDataMsg")
	serverproxy:Request(gCmd.CMD_METEOR_MAGIC_MODULE, gCmd.REQ_METEOR_MAGIC_INIT)
end
function meteorMagicCtrl:useItem(count)
	serverproxy = nil
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_METEOR_MAGIC_MODULE, gCmd.REQ_METEOR_MAGIC_USE_ITEM, nil)
end
function meteorMagicCtrl:openLight(projectID, idGroup)
	serverproxy = nil
	;(nil).projectID = projectID
	;(nil).idGroup = idGroup
	serverproxy:Request(gCmd.CMD_METEOR_MAGIC_MODULE, gCmd.REQ_METEOR_MAGIC_OPEN_LIGHT, nil)
end
function meteorMagicCtrl:closeLight(projectID, nType)
	serverproxy = nil
	;(nil).projectID = projectID
	;(nil).nType = nType
	serverproxy:Request(gCmd.CMD_METEOR_MAGIC_MODULE, gCmd.REQ_METEOR_MAGIC_CLOSE_LIGHT, nil)
end
function meteorMagicCtrl:openActive(projectID, nType)
	serverproxy = nil
	;(nil).projectID = projectID
	;(nil).nType = nType
	serverproxy:Request(gCmd.CMD_METEOR_MAGIC_MODULE, gCmd.REQ_METEOR_MAGIC_OPEN_ACTIVATE, nil)
end
function meteorMagicCtrl:closeActive(projectID, nType)
	serverproxy = nil
	;(nil).projectID = projectID
	;(nil).nType = nType
	serverproxy:Request(gCmd.CMD_METEOR_MAGIC_MODULE, gCmd.REQ_METEOR_MAGIC_CLOSE_ACTIVATE, nil)
end
function meteorMagicCtrl:changeProject(newProjectID)
	serverproxy = nil
	;(nil).newProjectID = newProjectID
	serverproxy:Request(gCmd.CMD_METEOR_MAGIC_MODULE, gCmd.REQ_METEOR_MAGIC_CHANGE_PROJECT, nil)
end
function meteorMagicCtrl:modifyName(projectID, name)
	serverproxy = nil
	;(nil).projectID = projectID
	;(nil).name = name
	serverproxy:Request(gCmd.CMD_METEOR_MAGIC_MODULE, gCmd.REQ_METEOR_MAGIC_MODIFY_NAME, nil)
end
function meteorMagicCtrl:useSkill(idGroup)
	serverproxy = nil
	;(nil).idGroup = idGroup
	serverproxy:Request(gCmd.CMD_METEOR_MAGIC_MODULE, gCmd.REQ_METEOR_MAGIC_USE_SKILL, nil)
end
function meteorMagicCtrl:openLights(projectID, idGroupArray)
	serverproxy = nil
	;(nil).projectID = projectID
	;(nil).idGroupArray = idGroupArray
	serverproxy:Request(gCmd.CMD_METEOR_MAGIC_MODULE, gCmd.REQ_METEOR_MAGIC_OPEN_LIGHT_2, nil)
end
function meteorMagicCtrl:sendReqInitRsp(content)
	dump(content, "meteorMagicCtrl:sendReqInfoRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_METEOR_MAGIC"
		self.subMsg = "init"
		SoraDSendMessage(self)
		return
	end
	if content.err == gErrDef.Err_RAMADAN_LETTER_ACTIVITY_NOT_OPEN then
		self:resetData()
	end
end
function meteorMagicCtrl:useItemRsp(content)
	dump(content, "==useItemRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_METEOR_MAGIC"
		self.subMsg = "init"
		SoraDSendMessage(self)
		return
	end
end
function meteorMagicCtrl:openLightRsp(content)
	dump(content, "==openLightRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_METEOR_MAGIC"
		self.subMsg = "init"
		SoraDSendMessage(self)
		return
	end
end
function meteorMagicCtrl:closeLightRsp(content)
	dump(content, "==closeLightRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_METEOR_MAGIC"
		self.subMsg = "init"
		SoraDSendMessage(self)
		SoraDShowMsgTip(i18n("meteoritesmagic_text_28"))
		return
	end
end
function meteorMagicCtrl:openActiveRsp(content)
	dump(content, "==openActiveRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_METEOR_MAGIC"
		self.subMsg = "init"
		SoraDSendMessage(self)
		SoraDShowMsgTip(i18n("meteoritesmagic_text_19"))
		return
	end
end
function meteorMagicCtrl:closeActiveRsp(content)
	dump(content, "==meteorMagicCtrl：sendReqDonateRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_METEOR_MAGIC"
		self.subMsg = "init"
		SoraDSendMessage(self)
		SoraDShowMsgTip(i18n("meteoritesmagic_text_26"))
		return
	end
end
function meteorMagicCtrl:changeProjectRsp(content)
	dump(content, "==changeProjectRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_METEOR_MAGIC"
		self.subMsg = "init"
		SoraDSendMessage(self)
		SoraDShowMsgTip(i18n("meteoritesmagic_text_6"))
		return
	end
end
function meteorMagicCtrl:modifyNameRsp(content)
	dump(content, "==modifyNameRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_METEOR_MAGIC"
		self.subMsg = "init"
		SoraDSendMessage(self)
		return
	end
end
function meteorMagicCtrl:useSkillRsp(content)
	dump(content, "==useSkillRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_METEOR_MAGIC"
		self.subMsg = "init"
		SoraDSendMessage(self)
		_ENV = nil
		;(nil).skill = i18n(meteorMagicRead.getName(content.data.idGroup))
		SoraDShowMsgTip(i18n("common_text_4051", nil))
		return
	end
end
function meteorMagicCtrl:openLightsRsp(content)
	dump(content, "==openLightsRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_METEOR_MAGIC"
		self.subMsg = "init"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_METEOR_MAGIC_TALENTS"
		SoraDSendMessage(self)
		return
	end
end
function meteorMagicCtrl:getCurExp()
	if not self.data then
		return 0
	end
	return self.data.totalExp
end
function meteorMagicCtrl:getCurLv()
	if not self.data then
		return 0
	end
	return self.data.lv
end
function meteorMagicCtrl:getTalentNum()
	if not self.data then
		return 0
	end
	return self.data.talentNum
end
function meteorMagicCtrl:getCurProjectID()
	if not self.data then
		return 0
	end
	return self.data.projectID
end
function meteorMagicCtrl:getProjectIsActive(projectID)
	if not self.data then
		return false
	end
	return projectID == self:getCurProjectID()
end
function meteorMagicCtrl:getProjectData(projectID)
	if not self.data then
		self.data.active, _ENV, _ENV = nil, nil, self.data
		self.data.light, _ENV, self.data.costTalentNum = nil, nil, 0
		_ENV = nil
		;(nil).num = projectID
		self.data.name = i18n("meteoritesmagic_text_12", nil)
		self.data.skill, _ENV, self.data.projectID = i18n("meteoritesmagic_text_12", nil), i18n("meteoritesmagic_text_12", nil), 0
		return self.data
	end
	for i = 1, 6 do
		local projectData = self.data["magicProject" .. i]
		if projectData and projectData.projectID == projectID then
			return projectData
		end
	end
	;(1).active, _ENV, _ENV = 6, 6, (for index)
	;(1).light, _ENV, (1).costTalentNum = 6, 6, 0
	_ENV = nil
	;(nil).num = projectID
	;(1).name = i18n("meteoritesmagic_text_12", nil)
	;(1).skill, _ENV, (1).projectID = i18n("meteoritesmagic_text_12", nil), i18n("meteoritesmagic_text_12", nil), 0
	return 1
end
function meteorMagicCtrl:getBuffEffect(effectType)
	if not worldMapDefine.isInNebula() then
		return 0
	end
	local value = 0
	if self.skillBuffList then
		local tmpValue = self.skillBuffList[effectType] and self.skillBuffList[effectType] or 0
		value = value + tmpValue
	end
	return value
end
function meteorMagicCtrl:getBuffList()
	return self.buffList
end
function meteorMagicCtrl:getCostByLight(lightData, idGroups)
	if not lightData then
		return 0
	end
	local count = 0
	for k, v in pairs(idGroups) do
		local cost = lightData[tostring(v)] and lightData[tostring(v)] or 0
		count = count + cost
	end
	return count
end
function meteorMagicCtrl:getBuffListByProjectID(projectID)
	local _ENV, buffList
	local projectData = self:getProjectData(projectID)
	if not projectData then
		return buffList
	end
	for k, v in pairs(projectData.active) do
		local magicTree = meteorMagicRead.getMagicTree(k)
		if magicTree then
			for k1, v1 in pairs(magicTree.idGroup) do
				local lv = projectData.light[tostring(v1)] or 0
				local magicId = meteorMagicRead.getMagicId(v1, lv ~= 0 and lv or 1)
				local magicCfg = meteorMagicRead.getMagicCfg(magicId)
				if lv ~= 0 and magicCfg.isActive == 2 then
					for k2, v2 in pairs(magicCfg.buff) do
						if not buffList[k] then
							buffList[k], _ENV = buffList[k], buffList[k]
						end
						if not buffList[k][v2.buffType] then
							buffList[k][v2.buffType] = 0
						end
						buffList[k][v2.buffType] = buffList[k][v2.buffType] + v2.value
					end
				end
			end
		end
	end
	return buffList
end
function meteorMagicCtrl:getSkillList()
	local _ENV, skillList
	local projectData = self:getProjectData(self:getCurProjectID())
	if not projectData then
		return skillList
	end
	for k, v in pairs(meteorMagicRead.meteoritesmagicTree) do
		local magicTree = v
		if projectData.active[tostring(magicTree.type)] ~= nil then
			for k1, v1 in pairs(magicTree.idGroup) do
				local lv = projectData.light[tostring(v1)] or 0
				local magicId = meteorMagicRead.getMagicId(v1, lv ~= 0 and lv or 1)
				local magicCfg = meteorMagicRead.getMagicCfg(magicId)
				if magicCfg and magicCfg.isActive == 1 then
					local cdData = projectData.skill[tostring(v1)]
					_ENV = tostring(v1)
					tostring(v1).magicId = magicId
					tostring(v1).cfg = magicCfg
					tostring(v1).info = meteorMagicRead.getMagicInfo(v1)
					tostring(v1).lv = lv
					tostring(v1).isUnLock = lv ~= 0
					tostring(v1).cdEndtime = cdData and cdData.time or 0
					local tostring(v1).useNum, skill = cdData and cdData.playerUseNum or 0, tostring(v1)
					table.insert(skillList, skill)
				end
			end
		end
	end
	local _ENV, skillBuffList = (for generator), pairs(meteorMagicRead.meteoritesmagicTree)
	for k, v in pairs(projectData.skill) do
		local lv = projectData.light[k] or 0
		if lv ~= 0 and v.flag then
			local magicId = meteorMagicRead.getMagicId(k, lv)
			local magicCfg = meteorMagicRead.getMagicCfg(magicId)
			for k2, v2 in pairs(magicCfg.buff) do
				if not skillBuffList[v2.buffType] then
					skillBuffList[v2.buffType] = 0
				end
				skillBuffList[v2.buffType] = skillBuffList[v2.buffType] + v2.value
			end
		end
	end
	for k, v in pairs(self.data.otherSkill) do
		local magicId = meteorMagicRead.getMagicId(v.idGroup, v.lv)
		local magicCfg = meteorMagicRead.getMagicCfg(magicId)
		for k2, v2 in pairs(magicCfg.buff) do
			if not skillBuffList[v2.buffType] then
				skillBuffList[v2.buffType] = 0
			end
			skillBuffList[v2.buffType] = skillBuffList[v2.buffType] + v2.value
		end
	end
	return skillList, skillBuffList
end
function meteorMagicCtrl:getIsLvLight(magicID, projectID)
	local idGroup, lv = meteorMagicRead.getIdGroup(magicID)
	local projectData = self:getProjectData(projectID)
	if not projectData then
		return false
	end
	local curLv = projectData.light[tostring(idGroup)] or 0
	return lv <= curLv
end
function meteorMagicCtrl:getIsActiveType(projectID, nType)
	local projectData = self:getProjectData(projectID)
	if not projectData then
		return false
	end
	return projectData.active[tostring(nType)] ~= nil
end
function meteorMagicCtrl:getActiveTypeNum(projectID, nType)
	local projectData = self:getProjectData(projectID)
	if not projectData then
		return false
	end
	local activeNum = 0
	for k, v in pairs(projectData.active) do
		if v ~= 0 then
			activeNum = activeNum + 1
		end
	end
	return activeNum
end
function meteorMagicCtrl:isShowSkillBtn()
	if not commonCheck.METEOR_MAIGC then
		return false
	end
	if not worldMapDefine.isInNebula() then
		return false
	end
	if self.skillList == nil or #self.skillList <= 0 then
		return false
	end
	local publicUtil = include("publicUtil")
	local isSkillUnlock = false
	for i, v in ipairs(self.skillList) do
		if v.isUnLock then
			isSkillUnlock = publicUtil.getCount(v.cfg.needItem[1]) >= v.cfg.needItem[2] and (not v.cdEndtime or not (v.cdEndtime > serviceFunctions.systemTime()))
			if isSkillUnlock then
				break
			end
		end
	end
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local castleBid = BUILDID.CASTLE
	local buildCell = cityCtrl:getBuildCell(castleBid, 0)
	if nil == buildCell then
		return false
	end
	local nebulaPalaceCell = cityCtrl:getBuildCell(BUILDID.NEBULA_PALACE, 0)
	if nil == nebulaPalaceCell then
		return false
	end
	local castleLv = tonumber(buildCell.info.lv)
	local isLocked = castleLv < NEBULA_WARS_BUILD_305 or tonumber(nebulaPalaceCell.info.state) == BUILD_STATE.LOCK
	return not isLocked, isSkillUnlock
end
return meteorMagicCtrl
