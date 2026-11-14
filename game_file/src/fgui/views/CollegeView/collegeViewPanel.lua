local buildLogic = include("buildLogic")
local luckyBlessCtrl = SoraDGetCtrl("luckyBlessCtrl")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local collegeDesRead = include("collegeDesRead")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local buildDescribeRead = include("buildDescribeRead")
local waitQueueCtrl = SoraDGetCtrl("waitQueueCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local collegeViewPanel = class("collegeViewPanel", baseFguiPanel)
function collegeViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("collegeViewPanel:ctor", self.viewName)
end
function collegeViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function collegeViewPanel:onInit()
	print("=======collegeViewPanel:onInit")
	self.isHideCurrentSceneView = true
	self.luckyData, _ENV, self.bid = BUILDID.COLLEGE, BUILDID.COLLEGE, BUILDID.COLLEGE
	self.isInit = true
	self.fields.Com_title:initData("", handler(self, self.onClickClose))
	self.fields.bg:setVisible(true)
end
function collegeViewPanel:onShow()
	print("=======collegeViewPanel:onShow")
	SoraDPlaySound("uicontrol", 47)
	_UPVALUE8_ = SoraDPlaySound
	SoraDPlaySound[1] = TECHNOLOGY_ATTR.resource
	SoraDPlaySound[2] = TECHNOLOGY_ATTR.cityDevelop
	SoraDPlaySound[3] = TECHNOLOGY_ATTR.hero
	SoraDPlaySound[4] = TECHNOLOGY_ATTR.anchor
	SoraDPlaySound[5] = TECHNOLOGY_ATTR.military
	SoraDPlaySound[6] = TECHNOLOGY_ATTR.special
	SoraDPlaySound[7] = TECHNOLOGY_ATTR.soldier
	local SoraDPlaySound[8], collegeKey = TECHNOLOGY_ATTR.leader, SoraDPlaySound
	if IsArClient then
		table.insert(collegeKey, 7, TECHNOLOGY_ATTR.advancedmilitary)
	end
	self.collegeKey = collegeKey
	self:initData()
end
function collegeViewPanel:initData()
	print("collegeViewPanel:initData==========")
	local buildCell = cityCtrl:getBuildCellList(self.bid)
	local blv = buildCell[1].info.lv
	local warLv = buildLogic.transformBuildLvToWarLv(blv)
	if 0 < warLv then
		_ENV = nil
		;(nil).build = buildDescribeRead.getName(self.bid)
		;(nil).lv = warLv
		self.fields.Com_title:updateTitle(i18n("common_text_1957", nil))
	else
		_ENV = i18n("common_text_1957", nil)
		i18n("common_text_1957", nil).name = buildDescribeRead.getName(self.bid)
		i18n("common_text_1957", nil).lv = math.min(blv, CASTLE_MAXLV_NOWAR)
		self.fields.Com_title:updateTitle(i18n("common_text_334", i18n("common_text_1957", nil)))
	end
	self.fields.Com_colleges:initData(self.collegeKey)
	self.tableStuding, self.studyingType = technologyCtrl:studyingTechnology()
	self.fields.Com_bottom:setControllers(self.tableStuding and 1 or 0)
	self.fields.Com_bottom:updateLuckyBless()
	self.fields.Usm_1:clearEffect()
	if self.tableStuding then
		self:initQueueData()
		if self.isInit then
			self.fields.bg:setVisible(false)
			self.fields.Usm_1:setEffectPath("et_xueyuan_study_start_1.usm,et_xueyuan_loop.usm", true)
		else
			self.fields.Usm_1:setEffectPath("et_xueyuan_study_start_2.usm,et_xueyuan_loop.usm", true, true)
			self.fields.bg:setVisible(true)
		end
	else
		if self.isInit then
			self.fields.bg:setVisible(false)
			self.fields.Usm_1:setEffectPath("et_xueyuan_stanbdy_start.usm", false)
		else
			self.fields.bg:setVisible(true)
		end
		self.fields.Com_bottom:initRecommendData()
	end
	self.isInit = false
end
function collegeViewPanel:updateLuckyBless()
	self.fields.Com_bottom:updateLuckyBless()
end
function collegeViewPanel:refreshWaitQueue()
	self.fields.Com_bottom:refreshWaitQueue()
end
function collegeViewPanel:initQueueData()
	self.queue = queueCtrl:queryQueue(gQueueTypeDef.technology_upgrade_queue)
	self.fields.Com_bottom:setStudyingQueue(self.tableStuding, self.queue)
	self.fields.Com_bottom:refreshWaitQueue()
end
function collegeViewPanel:initRecommendData()
	self.recommendData = technologyCtrl:getRecommendTech()
	self.fields.Text_noRecommend:setVisible(false)
	if #self.recommendData == 2 then
		self.fields.com_recommend1:setVisible(true)
		self.fields.com_recommend1:initData(self.recommendData[1])
		self.fields.com_recommend2:setVisible(true)
		self.fields.com_recommend2:initData(self.recommendData[2])
		self.fields.nline:setVisible(true)
	elseif #self.recommendData == 1 then
		self.fields.com_recommend1:setVisible(true)
		self.fields.com_recommend1:initData(self.recommendData[1])
		self.fields.com_recommend2:setVisible(false)
		self.fields.nline:setVisible(true)
	else
		self.fields.com_recommend1:setVisible(false)
		self.fields.com_recommend2:setVisible(false)
		self.fields.Text_noRecommend:setVisible(true)
		self.fields.nline:setVisible(false)
	end
end
function collegeViewPanel:endShow(...)
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	guideCtrl:updateGuideModule(gGuideModule.TECH_GUIDE)
end
function collegeViewPanel:gameGuide_getTarget(itemName, parameters)
	dump(parameters, "parameters")
	if itemName == "collegeMainSingle" then
		local collegeType = collegeDesRead.getType(parameters.tid)
		_ENV = nil
		;(nil).collegeType = collegeType
		gModuleMgr.sharedMgr("mildGuideManager"):setVariate("collegeMainSingle", nil)
		return self.fields.Com_colleges:gameGuide_getTarget(collegeType)
	elseif itemName == "CCS_collegeMainSingle_1" then
		return self.fields.Com_colleges:gameGuide_getTarget(TECHNOLOGY_ATTR.resource)
	else
		return self.fields[itemName]
	end
end
return collegeViewPanel
