local heroTrialltCtrl = include("heroTrialltCtrl")
local htMapMgr = include("htMapMgr")
local htBattleMgr = include("htBattleMgr")
local constantRead = include("constantRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_mapMode1 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://heroTrial/Com_mapMode1", Com_mapMode1)
fgui.register_extension("ui://heroTrial/Com_mapMode2", Com_mapMode1)
fgui.register_extension("ui://heroTrial/Com_mapMode3", Com_mapMode1)
function Com_mapMode1:onInit()
end
function Com_mapMode1:onShow()
	self.fields.mv_zhujue:setVisible(false)
end
function Com_mapMode1:init(mapId)
	self.mapId = mapId
	self.stageList = heroTrialltCtrl.getStageListOfMap(self.mapId)
	self:initData()
end
function Com_mapMode1:initData()
	for i = 1, 10 do
		self.fields["n" .. i]:initData(self.mapId, self.stageList[i])
	end
	for j = 1, 9 do
		local isUnlock = htBattleMgr.trialStatus and htBattleMgr.curTrialMap:getMapID() == self.mapId and self.stageList[j] < htBattleMgr.curTrialMap:getLastStage()
		for l = 1, 20 do
			local key = "p" .. j .. "_" .. l
			if self.fields[key] then
				self.fields[key]:setColor(isUnlock and cc.c3b(255, 255, 255) or cc.c3b(0, 0, 0))
			end
		end
	end
end
function Com_mapMode1:resetEntity()
	for i = 1, 10 do
		self.fields["n" .. i]:updateState()
	end
end
function Com_mapMode1:getEntity(stageId)
	for i = 1, 10 do
		if self.fields["n" .. i]:getStageId() == stageId then
			return self.fields["n" .. i]
		end
	end
end
function Com_mapMode1:getFromToPos(curStageId)
	local from, to
	for i = 1, 10 do
		if self.fields["n" .. i]:getStageId() == curStageId then
			from = self.fields["n" .. i]
			to = self.fields["n" .. i + 1]
			break
		end
	end
	return from, to
end
function Com_mapMode1:getStageImgAngel(pos1, pos2)
	local __, angle, isFlipX = worldMapFunction.getSoliderImgAngel(cc.p(pos1.x, -pos1.y), cc.p(pos2.x, -pos2.y))
	return angle, isFlipX
end
function Com_mapMode1:zhujueMove(curStageId)
	local from, to = self:getFromToPos(curStageId)
	if to then
		local time = constantRead.getConstValue("HERO_TRIAL_AUTOMATIC_TIME", 3)
		local pos1 = cc.p(from:getPositionX(), from:getPositionY())
		local pos2 = cc.p(to:getPositionX(), to:getPositionY())
		local angle, isFlipX = self:getStageImgAngel(pos1, pos2)
		self.fields.mv_zhujue:setFlip(isFlipX and 1 or 0)
		local frameName = string.format("3sgb_yd_%s", angle)
		self.fields.mv_zhujue:setAllFrameName(frameName .. "_%.2d.png", 1)
		self.fields.mv_zhujue:stopAllActions()
		self.fields.mv_zhujue:setPosition(pos1)
		self.fields.mv_zhujue:setVisible(true)
		_ENV = 1
		;(1)[1] = ffa.moveTo(time, pos2.x, pos2.y)
		;(1)[2] = ffa.callFunc(function()
			self.fields.mv_zhujue:setVisible(false)
		end)
		;(1)[3] = ffa.callFunc(function()
			self.fields.mv_zhujue:setVisible(false)
		end)
		;(1)[4] = ffa.callFunc(function()
			self.fields.mv_zhujue:setVisible(false)
		end)
		self.fields.mv_zhujue:runAction(ffa.seq(1))
	end
end
return Com_mapMode1
