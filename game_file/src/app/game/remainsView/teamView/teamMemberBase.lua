local remainsWarRead = include("remainsWarRead")
local scrollNode = include("scrollNode")
local teamMemberBase = class("teamMemberBase", function(target)
	return target
end)
function teamMemberBase:ctor()
	self.iconhead = SoraDGetChildByName(self, "icon_head")
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.txtScoreNum = SoraDGetChildByName(self, "Text_score_num")
	self.spScore = SoraDGetChildByName(self, "Sprite_score")
	self.spLeader = SoraDGetChildByName(self, "Sprite_leader")
	self.framehead = SoraDGetChildByName(self, "frame_head")
	if self.framehead then
		self.framehead = scrollNode.new(self.framehead)
	end
	self.tableSingleData, _ENV = scrollNode.new(self.framehead), scrollNode.new(self.framehead)
	self.handle = nil
	local x, y = self.spScore:getPosition()
	_ENV = nil
	;(nil).parent = self.spScore:getParent()
	;(nil).pos = cc.p(x, y - 10)
	;(nil).scale = 0.3
	self.starNode = SoraDGetRemainsWarStartNodeEx(0, nil)
end
function teamMemberBase:initData(data)
	self.tableSingleData = data
	self:updateInfo()
end
function teamMemberBase:updateInfo()
	SoraDGetHeadFromManager(self.iconhead, self.tableSingleData.headid, self.tableSingleData.avatar)
	local name = self.tableSingleData.nickName
	local allianceAbbr = self.tableSingleData.allianceAbbr
	if allianceAbbr ~= nil and string.len(allianceAbbr) > 0 then
		_ENV = nil
		;(nil).abbr = allianceAbbr
		;(nil).name = self.tableSingleData.nickName
		name = i18n("common_text_186", nil)
	end
	if self.tableSingleData.kid then
		name = name .. "#" .. tostring(self.tableSingleData.kid)
	end
	self.txtName:setString(name)
	local strScoreNum = string.formatnumberthousands(self.tableSingleData.rankScore)
	self.txtScoreNum:setString(strScoreNum)
	local imgScore = remainsWarRead.getDanIcon(self.tableSingleData.segment)
	self.spScore:setSpriteFrame(imgScore)
	if self.spLeader then
		self.spLeader:setVisible(self.tableSingleData.isLeader)
	end
	self.starNode.updateStar(self.tableSingleData.star)
end
function teamMemberBase:setScroll(scroll)
end
function teamMemberBase:setHandle(handle)
	self.handle = handle
	if self.framehead then
		self.framehead:setSwallowTouches(false)
		self.framehead:addTouchEventListener(handler(self, self.btnClickHeadCallBack))
	end
end
function teamMemberBase:btnClickHeadCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.handle then
			self.handle(self.tableSingleData)
		end
	end
end
return teamMemberBase
