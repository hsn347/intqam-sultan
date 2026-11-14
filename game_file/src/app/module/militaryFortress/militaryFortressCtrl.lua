local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local militaryFortressCtrl = class("militaryFortressCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local militaryFortressRead = include("militaryFortressRead")
local msgCtrl = include("msgCtrl")
function militaryFortressCtrl:ctor(properties)
	militaryFortressCtrl.super.ctor(self, properties)
	self:resetData()
end
function militaryFortressCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_MILITARY_FORTESS_MODULE, gCmd.REQ_MILITARY_FORTESS_INIT, handler(self, self.reqMilitaryFortessInitRsp))
	msgCtrl.register(gCmd.CMD_MILITARY_FORTESS_MODULE, gCmd.REQ_MILITARY_FORTESS_SET_HERO, handler(self, self.reqMilitaryFortessSetHeroRsp))
	msgCtrl.register(gCmd.CMD_MILITARY_FORTESS_MODULE, gCmd.REQ_MILITARY_FORTESS_CANCEL_HERO, handler(self, self.reqMilitaryFortessCancelHeroRsp))
	msgCtrl.register(gCmd.CMD_MILITARY_FORTESS_MODULE, gCmd.REQ_MILITARY_FORTESS_MASS_QUEUE_BUFFLIST, handler(self, self.reqMilitaryFortessQueueBuffListRsp))
	militaryFortressCtrl:reqMilitaryFortessInit()
end
function militaryFortressCtrl:Logout()
	militaryFortressCtrl.super.Logout(self)
	self:resetData()
end
function militaryFortressCtrl:resetData()
	self.heroPosList, _UPVALUE0_, self.camp, _UPVALUE0_ = nil, nil, nil, nil
end
function militaryFortressCtrl:reqMilitaryFortessInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_MILITARY_FORTESS_MODULE, gCmd.REQ_MILITARY_FORTESS_INIT, nil)
end
function militaryFortressCtrl:reqMilitaryFortessSetHero(data)
	serverproxy:Request(gCmd.CMD_MILITARY_FORTESS_MODULE, gCmd.REQ_MILITARY_FORTESS_SET_HERO, data)
end
function militaryFortressCtrl:reqMilitaryFortessCancelHero(data)
	serverproxy:Request(gCmd.CMD_MILITARY_FORTESS_MODULE, gCmd.REQ_MILITARY_FORTESS_CANCEL_HERO, data)
end
function militaryFortressCtrl:reqMilitaryFortessQueueBuffList(data)
	serverproxy:Request(gCmd.CMD_MILITARY_FORTESS_MODULE, gCmd.REQ_MILITARY_FORTESS_MASS_QUEUE_BUFFLIST, data)
end
function militaryFortressCtrl:reqMilitaryFortessInitRsp(content)
	self.camp = content.rspdata.camp
	if not content.rspdata.heroPosList then
		_ENV = content.rspdata.heroPosList
	end
	self.heroPosList = content.rspdata.heroPosList
	_ENV = nil
	;(nil).msg = "MESSAGE_MILITARY_FORTRESS_REFRESH"
	;(nil).buffList = content.rspdata
	SoraDSendMessage(nil)
end
function militaryFortressCtrl:reqMilitaryFortessSetHeroRsp(content)
	dump(content, "militaryFortressCtrl:reqMilitaryFortessSetHeroRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.camp = content.rspdata.camp
		self.heroPosList = content.rspdata.heroPosList
	elseif content.err == gErrDef.Err_MILITARY_ACTIVITY_HERO_STATE_ERROR then
		_ENV = content.err
		content.err[gHeroState.HERO_STATE_DEAD] = "fortress_text_22"
		content.err[gHeroState.HERO_STATE_CAPTURED] = "fortress_text_21"
		content.err[gHeroState.HERO_STATE_BATTLE] = "fortress_text_20"
		content.err[gHeroState.HERO_STATE_DEFEND] = "fortress_text_23"
		local content.err[gHeroState.HERO_STATE_ESCAPE], statueText = "fortress_text_21", content.err
		local heroCtrl = SoraDGetCtrl("heroCtrl")
		local heroState = heroCtrl:getHeroInfoByID(content.data.heroID).state
		if statueText[heroState] then
			_ENV = nil
			;(nil).var = i18n(statueText[heroState])
			SoraDShowMsgTip(i18n("fortress_text_24", nil))
			return
		end
	end
	_ENV = SoraDGetCtrl("heroCtrl")
	SoraDGetCtrl("heroCtrl").msg = "MESSAGE_MILITARY_FORTRESS_REFRESH"
	SoraDGetCtrl("heroCtrl").buffList = content.rspdata
	SoraDSendMessage((SoraDGetCtrl("heroCtrl")))
end
function militaryFortressCtrl:reqMilitaryFortessCancelHeroRsp(content)
	if content.err == gErrDef.Err_None then
		self.camp = content.rspdata.camp
		self.heroPosList = content.rspdata.heroPosList
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_MILITARY_FORTRESS_REFRESH"
		gErrDef.Err_None.buffList = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function militaryFortressCtrl:reqMilitaryFortessQueueBuffListRsp(content)
	_ENV = nil
	;(nil).msg = "MESSAGE_MILITARY_FORTRESS_REFRESH"
	;(nil).buffList = content.rspdata
	SoraDSendMessage(nil)
end
function militaryFortressCtrl:getHeroList(fortessType, campType)
	if not self.camp[tostring(fortessType) .. "_" .. tostring(campType)] then
		_ENV = self.camp[tostring(fortessType) .. "_" .. tostring(campType)]
	end
	return self.camp[tostring(fortessType) .. "_" .. tostring(campType)]
end
function militaryFortressCtrl:getHeroID(fortessType, campType, pos)
	return self:getHeroList(fortessType, campType)[tostring(pos)]
end
function militaryFortressCtrl:getBuffList(fortessType, campType)
	local militaryFortressRead, list
	local buffConfig = militaryFortressRead.getBuffConfig(campType, fortessType)
	local haveBuffConfig = self:getHeroList(fortessType, campType)
	dump(haveBuffConfig, "haveBuffConfig")
	for i, attrID in pairs(buffConfig) do
		local heroID = haveBuffConfig[tostring(i)]
		local attrValue = militaryFortressRead.getTotalModulus(campType, heroID) or 0
		militaryFortressRead = nil
		;(nil).attrID = attrID
		;(nil).attrValue = attrValue
		;(nil).heroID = heroID
		table.insert(list, nil)
	end
	return list
end
function militaryFortressCtrl:getCampBuffList(campType)
	local _ENV, list
	for i = 1, 4 do
		dump(self:getBuffList(i, campType), "self:getBuffList(i,campType)")
		for _, v in ipairs(self:getBuffList(i, campType)) do
			local heroCtrl = SoraDGetCtrl("heroCtrl")
			local heroInfo = heroCtrl:getHeroInfoByID(v.heroID)
			if v.attrValue ~= 0 and heroInfo.state == 1 then
				table.insert(list, v)
			end
		end
	end
	return list
end
function militaryFortressCtrl:getBuffByHeroPos(data)
	local militaryFortressRead, list
	local buffConfig = militaryFortressRead.getBuffConfig(data.campType, data.fortessType)
	local newAttrValue = militaryFortressRead.getTotalModulus(data.campType, data.heroID)
	local isUp
	if data.oldHeroID then
		local oldAttrValue = militaryFortressRead.getTotalModulus(data.campType, data.oldHeroID) or 0
		if newAttrValue < oldAttrValue then
			isUp = false
		elseif newAttrValue > oldAttrValue then
			isUp = true
		end
	end
	militaryFortressRead = data.oldHeroID
	data.oldHeroID.attrID = buffConfig[tonumber(data.pos)]
	data.oldHeroID.attrValue = newAttrValue
	data.oldHeroID.isUp = isUp
	table.insert(list, data.oldHeroID)
	return list
end
function militaryFortressCtrl:isHeroInGarrison(heroID)
	if self.heroPosList[tostring(heroID)] then
		return true
	end
	return false
end
function militaryFortressCtrl:getChoosedHeroInfo(heroID)
	return self.heroPosList[tostring(heroID)]
end
function militaryFortressCtrl:getChooseHeroList(fortessType, campType, pos)
	_ENV = nil
	;(nil)[1] = 5
	;(nil)[2] = 3
	;(nil)[3] = 4
	local _ENV, (nil)[4], fortessType_2_heroType = nil, 2, nil
	;(nil)[gHeroState.HERO_STATE_NORMAL] = 1
	;(nil)[gHeroState.HERO_STATE_BATTLE] = 2
	;(nil)[gHeroState.HERO_STATE_DEFEND] = 3
	;(nil)[gHeroState.HERO_STATE_CAPTURED] = 4
	;(nil)[gHeroState.HERO_STATE_ESCAPE] = 4
	local (nil)[gHeroState.HERO_STATE_DEAD], sortWeight = 5, nil
	local orignHeroID = self:getHeroID(fortessType, campType, pos)
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	local heroIDList = heroCtrl:filterHaveHerosList(2, fortessType_2_heroType[fortessType], orignHeroID)
	table.sort(heroIDList, function(l, r)
		local isLChoosed = self:isHeroInGarrison(l)
		local isRChoosed = self:isHeroInGarrison(r)
		local heroInfoL = heroCtrl:getHeroInfoByID(l)
		local heroInfoR = heroCtrl:getHeroInfoByID(r)
		local stateL = heroInfoL.state
		local stateR = heroInfoR.state
		if sortWeight[stateL] == sortWeight[stateR] then
			if isLChoosed == isRChoosed then
				local modulusL = militaryFortressRead.getTotalModulus(campType, l)
				local modulusR = militaryFortressRead.getTotalModulus(campType, r)
				if modulusL == modulusR then
					return r < l
				else
					return modulusL > modulusR
				end
			else
				return isRChoosed
			end
		else
			return sortWeight[stateL] < sortWeight[stateR]
		end
	end)
	return heroIDList
end
return militaryFortressCtrl
