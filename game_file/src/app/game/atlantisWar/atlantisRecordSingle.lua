local allianceDesRead = include("allianceDesRead")
local atlantisRecordSingle = class("atlantisRecordSingle", function(target)
	return target
end)
function atlantisRecordSingle:ctor()
	_UPVALUE3_ = nil
	self.ocxNum, (nil)[1] = nil, "icon_ranking_1.png"
	self.ocxNum, (nil)[2] = nil, "icon_ranking_2.png"
	self.ocxNum, (nil)[3] = nil, "icon_ranking_3.png"
	self.textBFRound = SoraDGetChildByName(self, "BitmapFontLabel_round")
	self.textTime = SoraDGetChildByName(self, "Text_Time")
	self.spS = SoraDGetChildByName(self, "Sprite_S")
	self.nodeNone = SoraDGetChildByName(self, "Node_None")
	self.nodeNone:setVisible(false)
	SoraDGetChildByName(self.nodeNone, "Text_None"):setString(i18n("common_text_480"))
	self.nodeTop = SoraDGetChildByName(self, "Node_Top3")
	self.top3Node = SoraDGetChildsArrayByName(self, "Node_SingleKing_", 3, 1)
	self:initEffect()
end
function atlantisRecordSingle:initEffect()
	include("atlantisWarUtil").playFireAnimation(self)
end
function atlantisRecordSingle:initData(data, otherData)
	dump(data, "data")
	self.kid = data.kid
	self.season = data.season
	self.rankData = data.rankData
	table.sort(self.rankData, function(l, r)
		return l.rank < r.rank
	end)
	self.textBFRound:setString(data.season)
	self.textTime:setString(os.date("!%Y.%m.%d", data.activeTime) .. "-" .. os.date("!%Y.%m.%d", data.finishTime))
	if next(self.rankData) then
		self.nodeNone:setVisible(false)
		self.nodeTop:setVisible(true)
		for i, v in ipairs(self.top3Node) do
			if self.rankData[i] then
				v:setVisible(true)
				self:nodeSingleKingRefresh(v, self.rankData[i], i)
			else
				v:setVisible(false)
			end
		end
	else
		self.nodeNone:setVisible(true)
		self.nodeTop:setVisible(false)
	end
end
function atlantisRecordSingle:nodeSingleKingRefresh(parent, data, index)
	local iconRank = SoraDGetChildByName(parent, "icon_ranking")
	local textName = SoraDGetChildByName(parent, "Text_Name")
	local btnDetail = SoraDGetChildByName(parent, "Button_Detail")
	btnDetail:setTouchEnabled(true)
	btnDetail:setTag(index)
	btnDetail:addTouchEventListener(handler(self, self.btnDetailClick))
	textName:setString(serviceFunctions.getKingdomFormatName(data.kingdomName, data.kid))
	local nodeFlag = SoraDGetChildByName(parent, "Node_Flag")
	allianceDesRead.getFlagWithParticle(data and data.flag or 1, nodeFlag)
	iconRank:setSpriteFrame(self.ocxNum[index])
end
function atlantisRecordSingle:btnDetailClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local index = target:getTag()
		local panel = SoraDCreatePanel("atlantisRecordDetailPop")
		_ENV = nil
		;(nil).season = self.season
		;(nil).rankData = self.rankData[index]
		panel:initData(nil)
		panel:show()
	end
end
return atlantisRecordSingle
