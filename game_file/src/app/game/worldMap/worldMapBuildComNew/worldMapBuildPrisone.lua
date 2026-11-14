local gametop = gModuleMgr.getObject("gametop")
local worldMapBuildComNew = include("worldMapBuildComNew")
local worldMapBuildPrisone = class("worldMapBuildPrisone", worldMapBuildComNew)
function worldMapBuildPrisone:ctor(...)
	worldMapBuildPrisone.super.ctor(self, ...)
end
function worldMapBuildPrisone:_initData(...)
	self.playerID = 0
	self.prisonerNum = 0
	_ENV = nil
	;(nil).byUID = true
	local isShowPrisionIcon = SoraDConfigGet("Game:castleChangeSetting:PrisonHeroIcon~bool", nil)
	if isShowPrisionIcon == nil then
		isShowPrisionIcon = true
	end
	self.isShowPrision = isShowPrisionIcon
end
function worldMapBuildPrisone:updateData(data)
	if data.playerID then
		self.playerID = data.playerID
	end
	if data.prisonerNum ~= nil then
		if worldMapDefine.isGardenKingdomID() then
			return
		end
		self.prisonerNum = data.prisonerNum
		self:updatePrisoneIn()
		return true
	end
end
function worldMapBuildPrisone:updatePrisoneIn(...)
	if self.prisonerNum > 0 then
		self:lazyCreatePrisoneInImage()
	elseif self.prisoneInIcon then
		self.prisoneInIcon:setVisible(false)
	end
end
function worldMapBuildPrisone:lazyCreatePrisoneInImage()
	local worldMapBuildEffect = self.target_:getBuildCom("worldMapBuildEffect")
	self.node_snowMan = worldMapBuildEffect:getNodeSnowMan()
	if not self.node_snowMan then
		if self.prisoneInIcon == nil then
			local prisoneInIcon = display.newSprite("#btn_hero_prison.png")
			prisoneInIcon:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 120))
			prisoneInIcon:setScale(1.3)
			prisoneInIcon:addTo(self.target_, 5)
			self.prisoneInIcon = prisoneInIcon
		else
			self.prisoneInIcon:setVisible(true)
		end
		local selfPlayerID = gametop.playertop_:getPlayerID() or 0
		if not self.isShowPrision and selfPlayerID == self.playerID then
			self.prisoneInIcon:setVisible(false)
		end
	elseif self.prisoneInIcon then
		self.prisoneInIcon:setVisible(false)
	end
end
function worldMapBuildPrisone:updatePrisionIcon(target, data)
	if self.prisoneInIcon then
		_ENV = nil
		;(nil).byUID = true
		local isShow = SoraDConfigGet("Game:castleChangeSetting:PrisonHeroIcon~bool", nil)
		if isShow == nil then
			isShow = true
		end
		local worldMapBuildEffect = self.target_:getBuildCom("worldMapBuildEffect")
		self.node_snowMan = worldMapBuildEffect:getNodeSnowMan()
		if self.node_snowMan then
			isShow = false
		end
		self.isShowPrision = isShow
		self:updatePrisoneIn()
	end
end
function worldMapBuildPrisone:getPrisonerNum(...)
	return self.prisonerNum
end
function worldMapBuildPrisone:getPrisoneInIcon(...)
	return self.prisoneInIcon
end
return worldMapBuildPrisone
