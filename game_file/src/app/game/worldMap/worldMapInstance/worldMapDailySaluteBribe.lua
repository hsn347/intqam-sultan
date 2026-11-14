local constantRead = include("constantRead")
local mapSyncUtilClient = include("mapSyncUtilClient")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local worldMapDailySaluteBribe = class("worldMapDailySaluteBribe", function()
	local target = include("worldMapInstance").new("worldMapDailySaluteBribe")
	return target
end)
function worldMapDailySaluteBribe:ctor()
	self:_initUI()
	self:_initData()
end
function worldMapDailySaluteBribe:_initData()
end
function worldMapDailySaluteBribe:_initUI()
	local obj = fguiHelper.createObject("Activity_9001689", "worldMapFastBox")
	obj:addTo(self)
	self.fields = fguiHelper.get_fields(obj)
	self.fields.mv1:setAllFrameName("dh_Tex_XL_bcxt0702_%.3d.png", 1)
	self.fields.mv2:setAllFrameName("dh_SSbj_%.2d.png", 1)
	self.fields.mv3:setAllFrameName("dh_Tex_XL_bcxt0703_%.3d.png", 1)
	self.fields.mv4:setAllFrameName("dh_tsrwsx_%.2d.png", 1)
	self.fields.mv2:setPlaySettings(0, -1, 1, -1)
	self.fields.Label_time:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("daily_salute_text31", nil)
	end)
end
function worldMapDailySaluteBribe:initInstanceData(siteClassID, siteData, objId)
	self.siteClassID = siteClassID
	self:updateData(siteData)
end
function worldMapDailySaluteBribe:updateData(data)
	dump(data, "worldMapDailySaluteBribe:updateData")
	if not data then
		return
	end
	self.data = data
	local bribePickNum = constantRead.getConstValue("DAILY_SALUTE_BRIBE_PICKUP_NUM")
	if not self.data.collMap then
		_ENV = self.data.collMap
	end
	local collNum = table.nums(self.data.collMap)
	_ENV = nil
	;(nil).num1 = bribePickNum - collNum
	;(nil).num2 = bribePickNum
	self.fields.Text_count:setString(i18n("daily_salute_text32", nil))
	local bribeTime = constantRead.getConstValue("DAILY_SALUTE_BRIBE_TIME")
	local leftTime = self.data.createTime + bribeTime - serviceFunctions.systemTime()
	if 0 < leftTime then
		self.fields.Label_time:beginTime(leftTime)
	end
end
function worldMapDailySaluteBribe:getInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	if isSelfKindom and SoraDGetCtrl("lordInfoCtrl"):isInSelfKid() then
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_9001689_reward
		table.insert(buttonTypeArray, nil)
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_9001689_claim
		table.insert(buttonTypeArray, nil)
	end
	return buttonTypeArray
end
function worldMapDailySaluteBribe:onClickTipButton(tipButtonType, tipButtonData, tipButtonExtra)
