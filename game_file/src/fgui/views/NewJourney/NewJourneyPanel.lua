local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local cumuActiveCtrl = SoraDGetCtrl("cumuActiveCtrl")
local journeyCfg = require("app." .. LocalTblPath .. ".config_client.journey")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NewJourneyPanel = class("NewJourneyPanel", baseFguiPanel)
function NewJourneyPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function NewJourneyPanel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NewJourney"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function NewJourneyPanel:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.Usm_1:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self.fields.Usm_2:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self.fields.Usm_1:setPrepareCallback(function()
		local effect = self.fields.Usm_1:getCriSprite()
		effect:setOpacity(0)
		effect:runAction(cca.fadeIn(1))
		self.fields.Usm_1:getCriSprite():start()
	end)
end
function NewJourneyPanel:onItemRenderer(index, obj)
	obj:initData(self.cfgs[index + 1])
end
function NewJourneyPanel:onShow()
	self.fields.List:getGroup():ensureBoundsCorrect()
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NEW_SERVER_JOURNEY_ACTIVITY)
	if eventTime then
		self.Text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
		if G_IS_UNITY then
			self.fields.Image_shalou.relations:clearAll()
		else
			self.fields.Image_shalou:relations():clearAll()
		end
		self.fields.Text_time:setPivot(0, 0)
	end
	self:initData()
end
function NewJourneyPanel:initData()
	local crazyTrioData = cumuActiveCtrl:getCrazyTrioData()
	local curCrazyIndex = table.nums(crazyTrioData.receive) + 1
	local cumuActiveCtrl, activity2cfg = crazyTrioData.receive, crazyTrioData.receive
	for _, v in ipairs(journeyCfg) do
		if v.activityId == 1 then
			if not activity2cfg[v.activityId] or curCrazyIndex >= v.identical and v.identical > activity2cfg[v.activityId].identical then
				print(v.ID, v.identical)
				activity2cfg[v.activityId] = v
			end
		else
			activity2cfg[v.activityId] = v
		end
	end
	self.cfgs, cumuActiveCtrl = ipairs(journeyCfg)
	for _, v in pairs(activity2cfg) do
		table.insert(self.cfgs, v)
	end
	table.sort(self.cfgs, function(a, b)
		return a.rank < b.rank
	end)
	self.fields.List:setNumItems(#self.cfgs)
end
return NewJourneyPanel
