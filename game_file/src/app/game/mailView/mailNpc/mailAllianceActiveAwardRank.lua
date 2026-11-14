local allianceActiveltCtrl = include("allianceActiveltCtrl")
local mailNodeFactory = include("mailNodeFactory")
local mailAllianceActiveAwardRank = class("mailAllianceActiveAwardRank", function(target)
	return ccui.Layout:create()
end)
function mailAllianceActiveAwardRank:ctor()
	self:setSwallowTouches(false)
	self:setCascadeOpacityEnabled(true)
	self:setLayoutType(ccui.LayoutType.VERTICAL)
end
function mailAllianceActiveAwardRank:initWithData(data, contentType)
	local totalHeight = 0
	local type = contentType == gMailNPCContentType.Content_Alliance_Active_Daily_Inside_Rank_Notify and 1 or 2
	self.rankInfo = data.info
	if self.rankInfo and next(self.rankInfo) then
		for i, v in ipairs(allianceActiveltCtrl.getActiveMemberRankAward(type)) do
			if not self.rankInfo[v.rank[1]] then
				break
			end
			local height = self:createSingle(v)
			totalHeight = totalHeight + height
		end
	else
		_ENV = ipairs(allianceActiveltCtrl.getActiveMemberRankAward(type))
		ipairs(allianceActiveltCtrl.getActiveMemberRankAward(type)).fontSize = 22
		_ENV = self:createSingle(v)
		self:createSingle(v).num = data.pointNeed
		ipairs(allianceActiveltCtrl.getActiveMemberRankAward(type)).str = i18n(type == 1 and "mail_text_615" or "mail_text_617", (self:createSingle(v)))
		ipairs(allianceActiveltCtrl.getActiveMemberRankAward(type)).color = cc.c3b(57, 11, 11)
		ipairs(allianceActiveltCtrl.getActiveMemberRankAward(type)).autoHeight = true
		local textDes, autoHeight = mailNodeFactory:createTextWithBg(ipairs(allianceActiveltCtrl.getActiveMemberRankAward(type)))
		self:addChild(textDes)
		totalHeight = totalHeight + autoHeight
	end
	self.itemWidth = gMailDetaiViewWidth
	self.itemHeight = totalHeight
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
end
function mailAllianceActiveAwardRank:createSingle(info)
	local singleNode = include("mailAllianceActiveAwardNode").new()
	local _ENV, members = "mailAllianceActiveAwardNode", "mailAllianceActiveAwardNode"
	for i = info.rank[1], info.rank[2] do
		if self.rankInfo[i] then
			table.insert(members, self.rankInfo[i])
		else
			break
		end
	end
	singleNode:initWithData(info, members)
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = members
	_ENV, members.dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isHideTop = true
	members.dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, singleNode
	frameBoxInfoNode:initWithData(members)
	frameBoxInfoNode:addTo(self)
	return frameBoxInfoNode:getItemHeight()
end
function mailAllianceActiveAwardRank:getItemWidth()
	return self.itemWidth
end
function mailAllianceActiveAwardRank:getItemHeight()
	return self.itemHeight
end
return mailAllianceActiveAwardRank
