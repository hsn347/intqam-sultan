local resDesRead = include("resDesRead")
local buildLogic = include("buildLogic")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local cityInfoResViewPanel = class("cityInfoResViewPanel", baseFguiPanel)
function cityInfoResViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("cityInfoResViewPanel:ctor", self.viewName)
end
function cityInfoResViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function cityInfoResViewPanel:onInit()
	print("=======cityInfoResViewPanel:onInit")
	self.buildListData, _ENV, self.tableBars, _ENV = print, print, print, print
	self.fields.Com_title:initData("", handler(self, self.onClickClose))
	self.fields.Text_Basicincome:setString(i18n("common_text_414"))
	self.fields.Text_Totalbonus:setString(i18n("common_text_415"))
	self.fields.List_bars:setItemRenderer(handler(self, self.onBarsRenderer))
	self.fields.List_builds:setItemRenderer(handler(self, self.onBuildsRenderer))
	self.fields.Sprite_head:fixPos()
	self.fields.Text_Title:fixPos()
	self.fields.Text_Perhour:fixPos()
	self.fields.Text_Basicincome:fixPos()
	self.fields.Text_Incomehour:fixPos()
	self.fields.Text_Totalbonus:fixPos()
	self.fields.Text_Bonushour:fixPos()
end
function cityInfoResViewPanel:onBarsRenderer(index, obj)
	obj:initData(self.tableBars[index + 1])
end
function cityInfoResViewPanel:onBuildsRenderer(index, obj)
	obj:initData(self.buildListData[index + 1])
end
function cityInfoResViewPanel:onShow()
	print("=======cityInfoResViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.resid = self.param.resid
	local resName = resDesRead.getName(self.resid)
	self.fields.Com_title:updateTitle(resName)
	self.fields.Sprite_head:setSpriteFrame(resDesRead.getBIcon(self.resid))
	_ENV = resDesRead.getBIcon(self.resid)
	resDesRead.getBIcon(self.resid).name = resName
	self.fields.Text_Title:setString(i18n("common_text_411", resDesRead.getBIcon(self.resid)))
	self:initData()
end
function cityInfoResViewPanel:initData()
	buildLogic, self.buildListData, buildLogic = nil, nil, nil
	;(nil).skill = 0
	;(nil).tech = 0
	;(nil).vip = 0
	;(nil).build = 0
	;(nil).all = 0
	;(nil).totaladd = 0
	;(nil).activity_count = 0
	local (nil).wargem_count, additionCount = 0, nil
	local baseOutPutCount = 0
	local bid = buildLogic.getBuildID(self.resid)
	local bCellList = cityCtrl:getBuildCellList(bid)
	for k, v in pairs(bCellList) do
		local buildData = buildLogic.getResOutputHour(tonumber(v.info.bid), tonumber(v.info.lv), tonumber(v.info.iid))
		buildLogic = tonumber(v.info.iid)
		tonumber(v.info.iid).bid = tonumber(v.info.bid)
		tonumber(v.info.iid).iid = tonumber(v.info.iid)
		tonumber(v.info.iid).level = tonumber(v.info.lv)
		tonumber(v.info.iid).curval = buildData.baseoutput
		tonumber(v.info.iid).addition = buildData.totaladd
		tonumber(v.info.iid).double = buildData.add_tool
		tonumber(v.info.iid).updating = v.info.state
		table.insert(self.buildListData, tonumber(v.info.iid))
		baseOutPutCount = baseOutPutCount + buildData.baseoutput
		additionCount.skill = additionCount.skill + buildData.skill_count
		additionCount.tech = additionCount.tech + buildData.tech_count
		additionCount.vip = additionCount.vip + buildData.vip_count
		additionCount.build = additionCount.build + buildData.build_count
		additionCount.activity_count = additionCount.activity_count + (buildData.activity_count or 0)
		additionCount.wargem_count = additionCount.wargem_count + (buildData.wargem_count or 0)
		additionCount.all = additionCount.all + buildData.total
		additionCount.totaladd = additionCount.totaladd + (buildData.skill_count + buildData.tech_count + buildData.vip_count + buildData.build_count + buildData.wargem_count)
	end
	buildLogic = nil
	;(nil).var = string.formatnumberthousands(additionCount.all)
	self.fields.Text_Perhour:setString(i18n("%{var}/h", nil))
	buildLogic = i18n("%{var}/h", nil)
	i18n("%{var}/h", nil).var = string.formatnumberthousands(baseOutPutCount)
	self.fields.Text_Incomehour:setString(i18n("%{var}/h", i18n("%{var}/h", nil)))
	local totalCurVal = 0
	buildLogic, buildLogic = i18n("%{var}/h", i18n("%{var}/h", nil))
	i18n("%{var}/h", i18n("%{var}/h", nil)).title = i18n("common_text_416")
	i18n("%{var}/h", i18n("%{var}/h", nil)).max = additionCount.totaladd
	buildLogic, self.fields.Text_Incomehour[1], i18n("%{var}/h", i18n("%{var}/h", nil)).curval = i18n("%{var}/h", i18n("%{var}/h", nil))
	i18n("%{var}/h", i18n("%{var}/h", nil)).title = i18n("common_text_417")
	i18n("%{var}/h", i18n("%{var}/h", nil)).max = additionCount.totaladd
	buildLogic, self.fields.Text_Incomehour[2], i18n("%{var}/h", i18n("%{var}/h", nil)).curval = i18n("%{var}/h", i18n("%{var}/h", nil))
	i18n("%{var}/h", i18n("%{var}/h", nil)).title = i18n("common_text_418")
	i18n("%{var}/h", i18n("%{var}/h", nil)).max = additionCount.totaladd
	buildLogic, self.fields.Text_Incomehour[3], i18n("%{var}/h", i18n("%{var}/h", nil)).curval = i18n("%{var}/h", i18n("%{var}/h", nil))
	i18n("%{var}/h", i18n("%{var}/h", nil)).title = i18n("common_text_419")
	i18n("%{var}/h", i18n("%{var}/h", nil)).max = additionCount.totaladd
	buildLogic, self.fields.Text_Incomehour[4], i18n("%{var}/h", i18n("%{var}/h", nil)).curval = i18n("%{var}/h", i18n("%{var}/h", nil))
	i18n("%{var}/h", i18n("%{var}/h", nil)).title = i18n("common_text_4111")
	i18n("%{var}/h", i18n("%{var}/h", nil)).max = additionCount.totaladd
	self.tableBars, self.fields.Text_Incomehour[5], i18n("%{var}/h", i18n("%{var}/h", nil)).curval = self.fields.Text_Incomehour, i18n("%{var}/h", i18n("%{var}/h", nil))
	self.fields.List_bars:setNumItems(#self.tableBars)
	for k, v in ipairs(self.tableBars) do
		totalCurVal = totalCurVal + v.curval
	end
	buildLogic = i18n("%{var}/h", i18n("%{var}/h", nil))
	i18n("%{var}/h", i18n("%{var}/h", nil)).var = string.formatnumberthousands(math.floor(totalCurVal))
	i18n("%{var}/h", i18n("%{var}/h", nil)).add = fguiHelper.getColorString("#4CE61A", "+" .. string.formatnumberthousands(additionCount.activity_count) .. "/h")
	self.fields.Text_Bonushour:setString(i18n("%{var}/h%{add}", i18n("%{var}/h", i18n("%{var}/h", nil))))
	self.fields.List_builds:setNumItems(#self.buildListData)
end
return cityInfoResViewPanel
