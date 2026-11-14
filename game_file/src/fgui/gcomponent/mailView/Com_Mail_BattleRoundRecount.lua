local mailFunctions = include("mailFunctions")
local baseComponent = require("fgui.base.baseComponent")
local Com_Mail_BattleRoundRecount = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://mailView/Com_Mail_BattleRoundRecount", Com_Mail_BattleRoundRecount)
function Com_Mail_BattleRoundRecount:onInit()
	self.fields.list:setItemRenderer(handler(self, self.itemRenderer_list))
	self.fields.btn_arrow:addClickListener(handler(self, self.onClick_btn_arrow))
	self.fields.btn_detail:addClickListener(handler(self, self.onClick_btn_detail))
	self.fields.text_my:setString(i18n("battlelog_text_41"))
	self.fields.text_enmey:setString(i18n("battlelog_text_40"))
	self.isShowContent = true
	self:fixChildrenPos()
end
function Com_Mail_BattleRoundRecount:onShow()
end
function Com_Mail_BattleRoundRecount:initData(contentData, roundDatas, isDefense, showRound, preRealRound)
	self.isDefense = isDefense
	self.contentData = contentData
	if not contentData.battleDetails or not contentData.battleDetails.roundLiveNum then
		local _ENV, roundLiveNum = contentData.battleDetails.roundLiveNum, contentData.battleDetails.roundLiveNum
	end
	dump(roundLiveNum, "roundLiveNum")
	local attackTotalNum, defenceTotalNum = mailFunctions:getTotalNumStr(self.contentData.playerInfo1.fightSummary, self.contentData.playerInfo2.fightSummary, true)
	attackTotalNum = attackTotalNum or 0
	defenceTotalNum = defenceTotalNum or 0
	local myIdx = isDefense and 2 or 1
	local enemyIdx = isDefense and 1 or 2
	local myTotal = isDefense and defenceTotalNum or attackTotalNum
	local enemyTotal = isDefense and attackTotalNum or defenceTotalNum
	local realRound = roundDatas[1] and roundDatas[1][6] or 0
	print(realRound, preRealRound, "realRound, roundLiveNum")
	self.realRound = realRound
	if not roundLiveNum[tostring(realRound)] then
		_UPVALUE2_ = roundLiveNum[tostring(realRound)]
		roundLiveNum[tostring(realRound)][1] = 0
		local roundLiveNum[tostring(realRound)][2], curRoundData = 0, roundLiveNum[tostring(realRound)]
	end
	if realRound == 0 then
		_UPVALUE2_ = 0
		;(0)[1] = attackTotalNum
		;(0)[2] = defenceTotalNum
	end
	if not 0 and not roundLiveNum[tostring(preRealRound)] then
		_UPVALUE2_ = roundLiveNum[tostring(preRealRound)]
		roundLiveNum[tostring(preRealRound)][1] = 0
		local roundLiveNum[tostring(preRealRound)][2], preRoundData = 0, roundLiveNum[tostring(preRealRound)]
	end
	self.towerRoundData, _ENV = 0, 0
	if 2 < realRound and 1 < realRound - preRealRound then
		local realPreRoundData = roundLiveNum[tostring(realRound - 1)]
		dump(realPreRoundData, "realPreRoundData")
		if realPreRoundData then
			self.towerRoundData[1] = preRoundData[1] - realPreRoundData[1]
			self.towerRoundData[2] = preRoundData[2] - realPreRoundData[2]
			print(self.towerRoundData[1], self.towerRoundData[2], "self.towerRoundData")
		end
	end
	local myCurNum = curRoundData[myIdx] or 0
	local lastCurNum = preRoundData[myIdx] or myTotal
	local lastEnemyCurNum = preRoundData[enemyIdx] or enemyTotal
	local enemyCurNum = curRoundData[enemyIdx] or 0
	local mySub = lastCurNum - myCurNum
	local enemySub = lastEnemyCurNum - enemyCurNum
	self.fields.text_myTotal:setString(SoraDConvertNumberWithUnit(lastCurNum))
	self.fields.text_enemyTotal:setString(SoraDConvertNumberWithUnit(lastEnemyCurNum))
	self.fields.text_mySub:setString("-" .. SoraDConvertNumberWithUnit(mySub))
	self.fields.text_enemySub:setString("-" .. SoraDConvertNumberWithUnit(enemySub))
	if showRound ~= 0 or not i18n("battlelog_text_6") then
		_ENV = enemySub
		enemySub.num = showRound
	end
	self.fields.Label_title:setString((i18n("battlelog_text_5", enemySub)))
	self.fields.my_progress:setMax(myTotal)
	self.fields.enemy_progress:setMax(enemyTotal)
	self.fields.my_progress:setValue(myCurNum)
	self.fields.enemy_progress:setValue(enemyCurNum)
	self.fields.list:setVisible(0 < #roundDatas)
	self.roundDatas = roundDatas
	self.listHeight = 0
	if self.isShowContent then
		self.fields.list:setNumItems(#roundDatas)
	end
	self.fields.list:setHeight(self.listHeight)
end
function Com_Mail_BattleRoundRecount:itemRenderer_list(index, obj)
	local data = self.roundDatas[index + 1]
	if index ~= 0 or not self.towerRoundData then
		_ENV = self.towerRoundData
	end
	obj:initData(data, self.isDefense, self.towerRoundData)
	print("obj:getHeight()", obj:getHeight())
	self.listHeight = self.listHeight + obj:getHeight()
end
function Com_Mail_BattleRoundRecount:onClick_btn_arrow(context)
	SoraDPlaySound()
	local vLayout = self:getParent()
	local oldHeight = self:getHeight()
	self.isShowContent = not self.isShowContent
	self.fields.btn_arrow:setRotation(self.isShowContent and 0 or 180)
	self.fields.list:setVisible(self.isShowContent)
	self.fields.list:setHeight(self.isShowContent and self.listHeight or 0)
	local nowHeight = self:getHeight()
	local deltaY = nowHeight - oldHeight
	_ENV = nil
	;(nil).msg = "MESSAGE_MAIL_UI_ITEM_DETAIL_SIZE_CHANGE"
	;(nil).deltaY = deltaY
	;(nil).node = self:getParent()
	SoraDSendMessage(nil)
	local children = vLayout:getChildren()
	local contentHeight = 0
	for _, v in ipairs(children) do
		v:setY(contentHeight)
		local childHeight = v:getHeight()
		contentHeight = contentHeight + childHeight
	end
end
function Com_Mail_BattleRoundRecount:onClick_btn_detail(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).battleDetails = self.contentData.battleDetails
	;(nil).realRound = self.realRound
	;(nil).isDefense = self.isDefense
	uiManager:show("mailBattleRoundDetail", nil)
end
return Com_Mail_BattleRoundRecount
