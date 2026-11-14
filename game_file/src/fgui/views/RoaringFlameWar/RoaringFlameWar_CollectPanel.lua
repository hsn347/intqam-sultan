local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameWar_CollectPanel = class("RoaringFlameWar_CollectPanel", baseFguiPanel)
function RoaringFlameWar_CollectPanel:ctor(...)
	self.isLRU = true
	RoaringFlameWar_CollectPanel.super.ctor(self, ...)
	print("RoaringFlameWar_CollectPanel:ctor", self.viewName)
	self.selfUid = SoraDGetPlayerID()
end
function RoaringFlameWar_CollectPanel:onInit()
	print("=======RoaringFlameWar_CollectPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	self.fields.Text_noData:setString(i18n("flames_dunes_text171"))
	if not SoraDFIsRA() then
		self.view:fixChildrenPos()
	end
end
function RoaringFlameWar_CollectPanel:initCheatData(...)
	_UPVALUE0_ = nil
	;(nil).objId = 232
	_UPVALUE0_, _UPVALUE0_, (nil).camp = nil, nil, 1
	;(nil).beginTime = 1729503338
	;(nil).uid = 162
	;(nil).nickName = "Player_162"
	;(nil).imageId = 1401
	_UPVALUE0_, (nil)[1], (nil).avatar = nil, nil, ""
	;(nil).beginTime = 1729503338
	;(nil).uid = 1
	;(nil).nickName = "Player_1"
	;(nil).imageId = 1402
	self.param, (nil).collecterList, (nil)[2], (nil).avatar = nil, nil, nil, ""
end
function RoaringFlameWar_CollectPanel:endShow()
	print("=======RoaringFlameWar_CollectPanel:endShow")
	local objId = self.param.objId
	local subType = roaringFlameWarRead.getBuildSubType(objId)
	local buildLv = roaringFlameWarRead.getBuildLevel(objId)
	local buildName = roaringFlameWarRead.getBuildName(subType)
	local buildPos = roaringFlameWarRead.getBuildCoord(objId)
	_ENV = nil
	;(nil).level = buildLv
	;(nil).resName = buildName
	local titleStr = i18n("common_text_472", nil) .. "(" .. buildPos.x .. "," .. buildPos.y .. ")"
	self.fields.Panel_bg:setString(titleStr)
	local buildImage = roaringFlameWarRead.getBuildImage(subType)
	self.fields.Load_build:setURL(buildImage)
	local camp = self.param.camp
	local campName = i18n("common_text_480")
	if camp then
		campName = roaringFlameWarRead.getCampName(camp)
	end
	_ENV = nil
	;(nil).camp = campName
	self.fields.Text_camp:setString(i18n("flames_dunes_text166", nil))
	local collSpeed = roaringFlameWarUtil.getCollSpeed(objId)
	self.collSpeed = collSpeed
	local speedStr = string.formatnumberthousands(collSpeed)
	_ENV = i18n("flames_dunes_text166", nil)
	i18n("flames_dunes_text166", nil).val1 = speedStr
	self.fields.Text_speed:setString(i18n("flames_dunes_text167", i18n("flames_dunes_text166", nil)))
	if not self.param.collecterList then
		local _ENV, collecterList = self.param.collecterList, self.param.collecterList
	end
	local _ENV, temp = self.fields.Text_speed, self.fields.Text_speed
	local selfInfo
	for __, v in ipairs(collecterList) do
		if self.selfUid == v.uid then
			selfInfo = v
		else
			table.insert(temp, v)
		end
	end
	table.sort(temp, function(a, b)
		if a.beginTime ~= b.beginTime then
			return a.beginTime > b.beginTime
		end
		return a.uid < b.uid
	end)
	if selfInfo then
		table.insert(temp, 1, selfInfo)
	end
	self.memberList = temp
	_ENV = i18n("flames_dunes_text167", i18n("flames_dunes_text166", nil))
	i18n("flames_dunes_text167", i18n("flames_dunes_text166", nil)).num = #self.memberList
	self.fields.Text_member:setString(i18n("flames_dunes_text169", i18n("flames_dunes_text167", i18n("flames_dunes_text166", nil))))
	roaringFlameWarUtil = i18n("flames_dunes_text169", i18n("flames_dunes_text167", i18n("flames_dunes_text166", nil)))
	i18n("flames_dunes_text169", i18n("flames_dunes_text167", i18n("flames_dunes_text166", nil)))[1] = 100
	i18n("flames_dunes_text169", i18n("flames_dunes_text167", i18n("flames_dunes_text166", nil)))[2] = 200
	local array = roaringFlameWarRead.getConstValueArray("FLAMES_DUNES_RES_POINT", i18n("flames_dunes_text169", i18n("flames_dunes_text167", i18n("flames_dunes_text166", nil))))
	local resType = roaringFlameWarRead.getResTypeBySubType(subType)
	local resNeed = array[resType]
	local resName = roaringFlameWarRead.getResName(resType)
	_ENV = i18n("flames_dunes_text169", i18n("flames_dunes_text167", i18n("flames_dunes_text166", nil)))
	i18n("flames_dunes_text169", i18n("flames_dunes_text167", i18n("flames_dunes_text166", nil))).val1 = resNeed
	i18n("flames_dunes_text169", i18n("flames_dunes_text167", i18n("flames_dunes_text166", nil))).val2 = resName
	i18n("flames_dunes_text169", i18n("flames_dunes_text167", i18n("flames_dunes_text166", nil))).val3 = 1
	self.fields.Text_des:setString(i18n("flames_dunes_text170", i18n("flames_dunes_text169", i18n("flames_dunes_text167", i18n("flames_dunes_text166", nil)))))
	self.fields.List:setNumItems(#self.memberList)
	self.fields.Text_noData:setVisible(#self.memberList <= 0)
end
function RoaringFlameWar_CollectPanel:onItemRenderer(index, obj)
	local _fields = obj._fields
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
		_fields.Text_collecting:setString(i18n("common_text_830"))
	end
	local data = self.memberList[index + 1]
	_fields.Com_head:setHeadSprite(data.imageId, data.avatar)
	_fields.Text_name:setString(data.nickName or data.uid)
	if self.selfUid == data.uid then
		obj:getController("c1"):setSelectedIndex(1)
		local res = roaringFlameWarCtrl:getResMapData(self.param.objId)
		if res then
			local leftTime = res.endCollTime - serviceFunctions.systemTime()
			local timeMax = res.endCollTime - res.beginTime
			_fields.bar:setTime(leftTime, timeMax)
			_fields.bar:setTimeUpdateListener(function(...)
				self:updateSelfCollNum(_fields)
			end)
			self:updateSelfCollNum(_fields)
		end
	else
		obj:getController("c1"):setSelectedIndex(0)
	end
end
function RoaringFlameWar_CollectPanel:updateSelfCollNum(_fields)
	local objId = self.param.objId
	local curSpeed = self.collSpeed / 3600
	local totalNum = roaringFlameWarCtrl:getCurCollNum(objId, curSpeed) or 0
	roaringFlameWarCtrl = nil
	;(nil).count = math.floor(totalNum)
	_fields.Text_hasCollect:setString(i18n("common_text_475", nil))
end
return RoaringFlameWar_CollectPanel
