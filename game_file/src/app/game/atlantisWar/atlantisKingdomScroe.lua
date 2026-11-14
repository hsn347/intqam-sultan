local gametop = gModuleMgr.getObject("gametop")
local atlantisKingdomScroe = class("atlantisKingdomScroe", function(target)
	if target == nil then
		return SoraDCreateBasePanel("atlantisKingdomScroe")
	end
	return target
end)
function atlantisKingdomScroe:ctor()
	self.singleList, gametop, self.selfKid = gametop.playertop_:getKingdomID(), gametop.playertop_:getKingdomID(), gametop.playertop_:getKingdomID()
	self:initWidget()
end
function atlantisKingdomScroe:initWidget(...)
	SoraDGetAllChildFromWidget(self, self)
	self.Node_single:setVisible(false)
	self.Node_single_self:setVisible(false)
	self.Image_first:setVisible(false)
end
function atlantisKingdomScroe:initData(data)
	self.Node_single:setVisible(false)
	self.Node_single_self:setVisible(false)
	self.Image_first:setVisible(false)
	_UPVALUE2_, _UPVALUE3_ = nil, false
	_UPVALUE2_, (nil)[1] = "score", "score"
	_UPVALUE2_, (nil)[2] = "score", ">"
	_UPVALUE2_, ("score")[1] = "t", "t"
	_UPVALUE2_, ("score")[2] = "t", "<"
	;("t")[1] = "camp"
	;("t")[2] = ">"
	;(false)[1] = nil
	;(false)[2] = "score"
	;(false)[3] = "t"
	serviceFunctions.sort(data, false)
	self.firstData = data[1]
	local itemH = 24
	if self.firstData and self.firstData.score > 0 then
		self.Image_first:setVisible(true)
	end
	for i, v in ipairs(self.singleList) do
		v:removeFromParent()
	end
	self.singleList, _ENV = ipairs(self.singleList)
	for i, v in ipairs(data) do
		local single = self.singleList[i]
		if not single then
			single = self:createSingle(v)
			single:addTo(self.Node_content)
			single:setPosition(0, -itemH * (i - 1))
			table.insert(self.singleList, single)
		end
		self:refreshSingle(single, v)
	end
end
function atlantisKingdomScroe:createSingle(data)
	local single
	if data.kid == self.selfKid then
		single = self.Node_single_self:clone()
	else
		single = self.Node_single:clone()
	end
	single:setVisible(true)
	SoraDGetAllChildFromWidget(single, single)
	single.Text_kid:setString(string.format("#%d", data.kid))
	return single
end
function atlantisKingdomScroe:refreshSingle(single, data)
	local percent = 0
	local score_max = self.scoreMax or 0
	score_max = math.max(score_max, self.firstData.score)
	percent = data.score / score_max * 100
	single.LoadingBar_1:setPercent(percent)
	single.Text_score:setString(string.formatnumberthousands(data.score))
end
function atlantisKingdomScroe:setScoreMax(scoreMax)
	self.scoreMax = scoreMax
end
return atlantisKingdomScroe
