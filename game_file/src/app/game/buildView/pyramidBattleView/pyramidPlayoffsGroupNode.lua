local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local pyramidClientModule = include("pyramidClientModule")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local PyramidPlayoffsGroupNode = class("pyramidPlayoffsGroupNode", function(target)
	return target
end)
function PyramidPlayoffsGroupNode:ctor()
	self.oldActArray, _ENV, self.infoData, _ENV, self.isInit = nil, nil, nil, nil, false
	self.groupKey = "A"
	self.btnSelectTime = SoraDGetChildByName(self, "Button_selectTime")
	self.btnEnter = SoraDGetChildByName(self, "Button_enter")
	self.btnManager = SoraDGetChildByName(self, "Button_manager")
	self.btnSelectTime:setTitleText(i18n("common_text_4002"))
	self.btnEnter:setTitleText(i18n("common_text_3318"))
	self.btnManager:setTitleText(i18n("common_text_3317"))
	self.labelGroupName = SoraDGetChildByName(self, "Text_gruopName")
	self.labelState = SoraDGetChildByName(self, "Text_state")
	self.labelState = SoraDCreateTimerLabel(self, self.labelState)
	self.imgKing = SoraDGetChildByName(self, "Image_rootKing")
	self.nodeKingFlag = SoraDGetChildByName(self.imgKing, "Node_flag")
	self.labelKing = SoraDGetChildByName(self.imgKing, "Text_name")
	self.spriteCrown = SoraDGetChildByName(self.imgKing, "Sprite_crown")
	self.spriteCrown:setVisible(false)
	self.nodeKingFlag:setVisible(false)
	self.labelKing:setString(i18n("common_text_4001"))
	self.labelKing:setColor(cc.c3b(214, 203, 180))
	self.labelKing:setPositionX(self.imgKing:getContentSize().width * 0.5)
	self.labelKing:setContentSize(cc.size(200, 50))
	self.btnSelectTime:addTouchEventListener(handler(self, self.touchBtnClick))
	self.btnEnter:addTouchEventListener(handler(self, self.touchBtnClick))
	self.btnManager:addTouchEventListener(handler(self, self.touchBtnClick))
	SoraDAutoSizeButtonText(self.btnSelectTime, cc.size(180, 70))
	SoraDAutoSizeButtonText(self.btnEnter, cc.size(180, 70))
	SoraDAutoSizeButtonText(self.btnManager, cc.size(180, 70))
	self.lineClass = nil
	self.lineModule = nil
	self.BlockModule = nil
	self.lineOcx = nil
	self:createLineClass()
	self:createLineTbl()
	self:createBlockTbl()
end
function PyramidPlayoffsGroupNode:updateBtn()
	self.btnSelectTime:setVisible(false)
	self.btnEnter:setVisible(false)
	self.btnManager:setVisible(false)
	self.labelState:setVisible(false)
	if pyramidWarCtrl:findPostSeasonKnockoutGroup(allianceMgr:getOwnAid()) == self.groupKey then
		local _des, _ades, _ticket = pyramidClientModule.getDesFromPostSeasonState()
		local _state, leftTime, _aState = pyramidClientModule.getPostSeasonShowState()
		if _aState == gPinnacleSeasonState.NOT_APPLY then
			self.btnSelectTime:setVisible(true)
		elseif _aState == gPinnacleSeasonState.APPLY_ED then
			self.btnManager:setVisible(true)
		elseif _aState == gPinnacleSeasonState.PREPARE then
			self.btnManager:setVisible(true)
			self.btnEnter:setVisible(true)
			self.btnEnter:setTouchEnabled(false)
			self.btnEnter:setBright(false)
		elseif _aState == gPinnacleSeasonState.RUNNING then
			self.btnManager:setVisible(true)
			self.btnEnter:setVisible(true)
			self.btnEnter:setTouchEnabled(true)
			self.btnEnter:setBright(true)
		end
		if _ticket then
			self.labelState:setVisible(true)
			self.labelState:beginTime(_ticket)
			pyramidWarCtrl = allianceMgr:getOwnAid()
			allianceMgr:getOwnAid().time = SoraDConvertSecondToString(_ticket)
			self.labelState:setString(i18n(_ades, allianceMgr:getOwnAid()))
			self.labelState:setTimeLast(function(tick)
				_ENV = nil
				;(nil).time = tick
				local reText = i18n(_ades, nil)
				return reText
			end)
		end
	end
end
function PyramidPlayoffsGroupNode:touchBtnClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if target == self.btnSelectTime then
			SoraDCreatePanel("pyramidPlayoffsSignUp"):show()
		elseif target == self.btnEnter then
			local enterWarCondition = function(...)
				local armyCtrl = gametop.playertop_:getModule("armyCtrl")
				if armyCtrl:getTotalWoundedArmyCount() > 0 then
					SoraDShowMsgBox(i18n("common_text_3261"), i18n("common_text_402"), nil, function(eventType)
						if eventType == MSGBOX_CALLBACK_YES then
							local worldMapWarDef = include("worldMapWarDef")
							worldMapWarDef.openHospitalView()
						end
					end)
					return false
				end
				local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
				if kingdomMapCtrl.kingdomMapCell:hasWoundedQueueArmy() then
					SoraDShowMsgTip(i18n("common_text_3498"))
					return false
				end
				if kingdomMapCtrl:isHasMassQueue() then
					SoraDShowMsgTip(i18n("common_text_3262"))
					return false
				end
				return true
			end
			local enterBattle = function()
				if enterWarCondition() then
					SoraDShowLoading(SoraDSearchPanelFromManagerByName("pyramidPlayoffsView"))
					pyramidWarCtrl:pyramidwarEnterReq()
				end
			end
			pyramidClientModule.popSelectMenu(enterBattle)
		elseif target == self.btnManager then
			SoraDCreatePanel("pyramidBattleManager"):show()
		end
	end
end
function PyramidPlayoffsGroupNode:begin2Run(...)
	local _ENV, nextRoundList
	local _ENV, actArray
	for i = 1, 4 do
		local data = self.infoData[i]
		local value1 = data[1]
		local value2 = data[2]
		if value1 then
			_ENV = nil
			;(nil).aid = value1.aid
			;(nil).kid = value1.kid
			table.insert(nextRoundList, nil)
		end
		if value2 then
			_ENV = nil
			;(nil).aid = value2.aid
			;(nil).kid = value2.kid
			table.insert(nextRoundList, nil)
		end
	end
	for j = 1, math.min(pyramidWarCtrl.pinnacleRound, 3) do
		local actArray[j], _ENV, _ENV, tmpRoundList = data[1], data[1], self.infoData[i], self.infoData[i]
		for i, v in ipairs(nextRoundList) do
			if pyramidWarCtrl:getIsPromote(j, v.aid) then
				print("j ", j, " i ", i)
				table.insert(actArray[j], self.lineModule[j][i])
				table.insert(tmpRoundList, v)
			end
		end
		if 0 < #actArray[j] then
			nextRoundList = clone(tmpRoundList)
		else
			break
		end
		if 3 <= j then
			self.labelKing:setPositionX(103.83)
			self.labelKing:setContentSize(cc.size(160, 50))
			self:initSingleData(self.imgKing, nextRoundList[1])
			self.spriteCrown:setVisible(true)
			self.nodeKingFlag:setVisible(true)
		end
	end
	local needReset = false
	for i, v in ipairs(actArray) do
		if self.oldActArray[i] then
			if #self.oldActArray[i] ~= #v then
				needReset = true
				break
			end
		else
			needReset = true
			break
		end
	end
	self.oldActArray = clone(actArray)
	if needReset then
		self:reset()
		local index = 0
		local function loopLineRun()
			if actArray[index] and 0 < #actArray[index] then
				self:playBySpawn(actArray[index], loopLineRun)
			end
		end
		loopLineRun()
	end
end
function PyramidPlayoffsGroupNode:reset(...)
	for _, v in pairs(self.lineOcx) do
		v:reset()
	end
end
function PyramidPlayoffsGroupNode:updateView()
	if self.isInit then
		self:fillBlockInfo(self.infoData, self.groupKey)
	end
end
function PyramidPlayoffsGroupNode:fillBlockInfo(info, groupKey)
	self.infoData = info
	self.groupKey = groupKey
	_ENV = nil
	;(nil).rank = self.groupKey
	self.labelGroupName:setString(i18n("common_text_4016", nil))
	dump(self.BlockModule, "self.BlockModule")
	for i, v in ipairs(self.BlockModule) do
		if i % 2 == 0 then
			local groupIndex = i / 2
			local groupData = self.infoData[groupIndex]
			self:initSingleData(self.BlockModule[i - 1], groupData[1])
			self:initSingleData(v, groupData[2])
		end
	end
	self:updateBtn()
	self:begin2Run()
	self.isInit = true
end
function PyramidPlayoffsGroupNode:initSingleData(target, value)
	if target then
		local flag = target:getChildByName("Node_flag")
		local name = target:getChildByName("Text_name")
		if flag == nil then
			flag = self.nodeKingFlag
			flag:setVisible(true)
			name = self.labelKing
			name:setColor(cc.c3b(246, 198, 141))
			name:setPositionX(96.3)
			name:setContentSize(cc.size(145, 50))
		end
		if value.aid > 0 and not pyramidWarCtrl:getPostSeasonAidIsKnockout(value.aid) then
			local data = pyramidWarCtrl:getPostSeasonAllianceInfo(value.aid)
			_ENV = cc.size(145, 50)
			cc.size(145, 50).abbr = data.abbr
			cc.size(145, 50).name = data.name
			name:setString(i18n("common_text_186", cc.size(145, 50)) .. "#" .. data.kid)
			flag:removeAllChildren()
			allianceDesRead.getFlagWithParticle(data.flag, flag)
			if value.aid == allianceMgr:getOwnAid() and target:getChildByName("Image_light") == nil then
				local imgLight = ccui.ImageView:create("glow_pyramid_yellow.png", ccui.TextureResType.plistType)
				imgLight:setScale9Enabled(true)
				imgLight:setCapInsets(cc.rect(20, 20, 43, 43))
				imgLight:setName("Image_light")
				imgLight:setContentSize(cc.size(target:getContentSize().width + 8, target:getContentSize().height + 8))
				imgLight:setPosition(cc.p(0.5 * target:getContentSize().width, 0.5 * target:getContentSize().height))
				imgLight:addTo(target, -1)
			end
			local allianceJump = target:getChildByName("Button_showAlliance")
			allianceJump:addTouchEventListener(function(button, eventType)
				if eventType == ccui.TouchEventType.ended then
					SoraDPlaySound()
					local allianceQuery = gametop.playertop_:getModule("allianceQuery")
					SoraDShowLoading(SoraDSearchPanelFromManagerByName("pyramidPlayoffsView"))
					_ENV = SoraDSearchPanelFromManagerByName("pyramidPlayoffsView")
					SoraDSearchPanelFromManagerByName("pyramidPlayoffsView").from = "pyramidPlayoffsView"
					allianceQuery:reqAllianceInfo(value.kid, value.aid, SoraDSearchPanelFromManagerByName("pyramidPlayoffsView"))
				end
			end)
		else
			local fid = 1
			if 0 < value.aid then
				local data = pyramidWarCtrl:getPostSeasonAllianceInfo(value.aid)
				fid = data.flag
				_ENV = cc.p(0.5 * target:getContentSize().width, 0.5 * target:getContentSize().height)
				cc.p(0.5 * target:getContentSize().width, 0.5 * target:getContentSize().height).abbr = data.abbr
				cc.p(0.5 * target:getContentSize().width, 0.5 * target:getContentSize().height).name = data.name
				name:setString(i18n("common_text_186", cc.p(0.5 * target:getContentSize().width, 0.5 * target:getContentSize().height)) .. "#" .. data.kid)
				local allianceJump = target:getChildByName("Button_showAlliance")
				allianceJump:addTouchEventListener(function(button, eventType)
					if eventType == ccui.TouchEventType.ended then
						SoraDPlaySound()
						local allianceQuery = gametop.playertop_:getModule("allianceQuery")
						SoraDShowLoading(SoraDSearchPanelFromManagerByName("pyramidPlayoffsView"))
						_ENV = SoraDSearchPanelFromManagerByName("pyramidPlayoffsView")
						SoraDSearchPanelFromManagerByName("pyramidPlayoffsView").from = "pyramidPlayoffsView"
						allianceQuery:reqAllianceInfo(value.kid, value.aid, SoraDSearchPanelFromManagerByName("pyramidPlayoffsView"))
					end
				end)
			else
				flag:setVisible(false)
				fid = 1
				name:setString(i18n("common_text_927"))
			end
			self:changeBlock(target, fid, true)
		end
	end
end
function PyramidPlayoffsGroupNode:createBlockTbl(...)
	self.BlockModule, _UPVALUE0_ = nil, nil
	for i = 1, 8 do
		self.BlockModule[i] = self:getChildByName("Image_root_" .. i)
	end
end
function PyramidPlayoffsGroupNode:changeBlock(ocx, fid, greyOrWhite)
	if ocx then
		if greyOrWhite then
			ocx:getVirtualRenderer():setState(1)
			ocx:getChildByName("Node_flag"):removeAllChildren()
			ocx:getChildByName("Node_flag"):addChild(SoraDGetAllianceFlagByFid(fid, true))
			ocx:getChildByName("Text_name"):setColor(cc.c3b(130, 130, 130))
		else
			ocx:getVirtualRenderer():setState(0)
			ocx:getChildByName("Node_flag"):removeAllChildren()
			ocx:getChildByName("Node_flag"):addChild(SoraDGetAllianceFlagByFid(fid))
			ocx:getChildByName("Text_name"):setColor(cc.c3b(246, 198, 141))
		end
	end
end
function PyramidPlayoffsGroupNode:createLineTbl(...)
	self.lineOcx, _UPVALUE0_ = nil, nil
	for i = 1, 29 do
		self.lineOcx[i] = self:getChildByName("Light_line_" .. i)
		self.lineOcx[i] = self.lineClass.new(self.lineOcx[i])
	end
	self.lineModule, _UPVALUE0_ = 1, (for index)
	_UPVALUE3_, _UPVALUE0_ = 1, 29
	_UPVALUE3_, (29)[1], (1)[1] = 1, 1, self.lineOcx[1]
	_UPVALUE3_, (29)[1], (1)[2] = 1, 1, self.lineOcx[9]
	_UPVALUE3_, (29)[1], (1)[3] = 1, 1, self.lineOcx[17]
	_UPVALUE3_, (29)[2], (1)[1] = 1, 1, self.lineOcx[2]
	_UPVALUE3_, (29)[2], (1)[2] = 1, 1, self.lineOcx[10]
	_UPVALUE3_, (29)[2], (1)[3] = 1, 1, self.lineOcx[17]
	_UPVALUE3_, (29)[3], (1)[1] = 1, 1, self.lineOcx[3]
	_UPVALUE3_, (29)[3], (1)[2] = 1, 1, self.lineOcx[11]
	_UPVALUE3_, (29)[3], (1)[3] = 1, 1, self.lineOcx[18]
	_UPVALUE3_, (29)[4], (1)[1] = 1, 1, self.lineOcx[4]
	_UPVALUE3_, (29)[4], (1)[2] = 1, 1, self.lineOcx[12]
	_UPVALUE3_, (29)[4], (1)[3] = 1, 1, self.lineOcx[18]
	_UPVALUE3_, (29)[5], (1)[1] = 1, 1, self.lineOcx[5]
	_UPVALUE3_, (29)[5], (1)[2] = 1, 1, self.lineOcx[13]
	_UPVALUE3_, (29)[5], (1)[3] = 1, 1, self.lineOcx[19]
	_UPVALUE3_, (29)[6], (1)[1] = 1, 1, self.lineOcx[6]
	_UPVALUE3_, (29)[6], (1)[2] = 1, 1, self.lineOcx[14]
	_UPVALUE3_, (29)[6], (1)[3] = 1, 1, self.lineOcx[19]
	_UPVALUE3_, (29)[7], (1)[1] = 1, 1, self.lineOcx[7]
	_UPVALUE3_, (29)[7], (1)[2] = 1, 1, self.lineOcx[15]
	_UPVALUE3_, (29)[7], (1)[3] = 1, 1, self.lineOcx[20]
	self.lineModule[1], (29)[8], (1)[1] = 29, 1, self.lineOcx[8]
	self.lineModule[1], (29)[8], (1)[2] = 29, 1, self.lineOcx[16]
	self.lineModule[1], (29)[8], (1)[3] = 29, 1, self.lineOcx[20]
	_UPVALUE2_, _UPVALUE0_ = 1, 29
	_UPVALUE2_, (29)[1], (1)[1] = 1, 1, self.lineOcx[21]
	_UPVALUE2_, (29)[1], (1)[2] = 1, 1, self.lineOcx[25]
	_UPVALUE2_, (29)[2], (1)[1] = 1, 1, self.lineOcx[22]
	_UPVALUE2_, (29)[2], (1)[2] = 1, 1, self.lineOcx[25]
	_UPVALUE2_, (29)[3], (1)[1] = 1, 1, self.lineOcx[23]
	_UPVALUE2_, (29)[3], (1)[2] = 1, 1, self.lineOcx[26]
	self.lineModule[2], (29)[4], (1)[1] = 29, 1, self.lineOcx[24]
	self.lineModule[2], (29)[4], (1)[2] = 29, 1, self.lineOcx[26]
	_UPVALUE2_, _UPVALUE0_ = 1, 29
	_UPVALUE2_, (29)[1], (1)[1] = 1, 1, self.lineOcx[27]
	_UPVALUE2_, (29)[1], (1)[2] = 1, 1, self.lineOcx[29]
	self.lineModule[3], (29)[2], (1)[1] = 29, 1, self.lineOcx[28]
	self.lineModule[3], (29)[2], (1)[2] = 29, 1, self.lineOcx[29]
end
function PyramidPlayoffsGroupNode:playBySeq(args)
	local args = args
	local index = 0
	local function loop2Play(...)
		if args[index] then
			self:loadLine(args[index], loop2Play)
		end
	end
	loop2Play()
end
function PyramidPlayoffsGroupNode:playBySpawn(args, endCB)
	local args = args
	for i, v in ipairs(args) do
		if i >= #args then
			self:loadLine(v, endCB)
		else
			self:loadLine(v)
		end
	end
end
function PyramidPlayoffsGroupNode:loadLine(tbl, endCB)
	local index = 0
	local function loop4Run(...)
		if tbl[index] then
			tbl[index]:setHandle(loop4Run)
			tbl[index]:run()
		elseif endCB then
			endCB()
		end
	end
	loop4Run()
end
function PyramidPlayoffsGroupNode:createLineClass()
	self.lineClass = class("PyramidPlayoffsLine", function(target)
		return target
	end)
	function self.lineClass:ctor()
		self.oSize = self:getContentSize()
		self:reset()
	end
	function self.lineClass:reset(...)
		self:stopAllActions()
		self:setContentSize(cc.size(0, self.oSize.height))
	end
	function self.lineClass:setHandle(handl)
		self.callBack = handl
	end
	function self.lineClass:run(...)
		self:stopAllActions()
		self:reset()
		local starW = 0
		local callFunc = cca.callFunc(function()
			if starW < self.oSize.width then
				self:setContentSize(cc.size(starW, self.oSize.height))
			else
				self:stopAllActions()
				if self.callBack then
					self.callBack()
				end
			end
		end)
		self:runAction(cc.RepeatForever:create(cca.seq(callFunc)))
	end
end
return PyramidPlayoffsGroupNode
