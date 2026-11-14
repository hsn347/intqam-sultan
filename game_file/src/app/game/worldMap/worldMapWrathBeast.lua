local worldMapBoss = include("worldMapBoss")
local instanceFactory = include("instanceFactory")
local worldMapWrathBeast = class("worldMapWrathBeast", worldMapBoss)
function worldMapWrathBeast:ctor()
	print("==worldMapWrathBeast:ctor==")
	self.lastHP = 0
	self.normalHP = 0
	self.lifeNum = 0
	self.orgLifeNum = 0
	worldMapWrathBeast.super.ctor(self)
end
function worldMapWrathBeast:initInstanceData(bossClassID, imgNameAngle, isFlipX, bossData)
	self.lastHP = bossData.lastHP
	self.normalHP = bossData.normalHP
	self.lifeNum = bossData.lifeNum
	worldMapWrathBeast.super.initInstanceData(self, bossData.bossType, imgNameAngle, isFlipX, bossData)
end
function worldMapWrathBeast:onClickInstance(onShowView)
	self:playClickSound()
	local selectShowPanel = SoraDCreatePanel("worldMapWrathBeastInfo")
	selectShowPanel:setPosition(cc.p(display.width / 2, display.height / 2))
	selectShowPanel:setTilePoint(cc.p(self.tilePoint.x, self.tilePoint.y))
	selectShowPanel:initData(self)
	selectShowPanel:show()
	return selectShowPanel, true
end
function worldMapWrathBeast:updateProcessBar()
	if self.leftLife and self.leftLife > 0 then
		self.progressBar:setPercent(self.leftLife)
		self.progressBar:setTextCount(self.lifeNum)
	else
		self.progressBar:setVisible(false)
	end
end
function worldMapWrathBeast:updateData(data)
	if data.lifeNum then
		self.lifeNum = data.lifeNum
	end
	worldMapWrathBeast.super.updateData(self, data)
end
function worldMapWrathBeast:recalculateLeftLife(...)
	if self.leftLife <= self.lastHP then
		self.leftLife = tonumber(string.format("%.2f", self.leftLife / self.lastHP * 100))
	else
		self.leftLife = self.leftLife - self.lastHP - (self.lifeNum - 2) * self.normalHP
		self.leftLife = tonumber(string.format("%.2f", self.leftLife / self.normalHP * 100))
	end
end
function worldMapWrathBeast:setScaleAndPositionY(...)
	if self.bossClassID == gBossType.wrathBeastDrqsc then
		self.bossImg:setScale(1.5)
		self.bossImg:setPositionY(0)
	elseif self.bossClassID == gBossType.wrathBeastDrq then
		self.bossImg:setScale(1.3)
		self.bossImg:setPositionY(20)
	end
end
return worldMapWrathBeast
