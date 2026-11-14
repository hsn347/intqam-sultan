local cityBuildViewDef = include("cityBuildViewDef")
local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildFarm = class("cityBuildFarm", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildFarm:ctor()
	self.viewModel = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
end
function cityBuildFarm:loadView()
	self:loadBaseView()
end
function cityBuildFarm:updateViewModel()
	local bid = self:getBuildBid()
	local viewModel = self:getViewModel()
	if self.viewModel ~= viewModel then
		self.viewModel = viewModel
		self:updateViewByModel(viewModel)
	end
end
function cityBuildFarm:updateViewByModel(viewModel)
	local bid = self:getBuildBid()
	if bid ~= BUILDID.FARM then
		return
	end
	local updateFunc = "updateViewModel" .. viewModel
	self[updateFunc](self)
end
function cityBuildFarm:getViewModel()
	local tblViewModelCfg = cityBuildViewDef.tblViewModelFarm
	local lv = self:getBuildLv()
	return self:getViewModelByLv(lv, tblViewModelCfg)
end
function cityBuildFarm:updateViewModel1()
end
function cityBuildFarm:updateViewModel2()
	self:loadNodeByName("buildAnimationNormalType1_1")
	self:loadNodeByName("nt_decorate_02")
end
function cityBuildFarm:updateViewModel3()
	self:loadNodeByName("nt_shuiqu")
	self:loadNodeByName("buildAnimationNormalType1_1")
	self:loadNodeByName("nt_decorate_03")
end
function cityBuildFarm:updateViewModel4()
	self:loadNodeByName("nt_shuiqu_02")
	self:loadNodeByName("buildAnimationNormalType1_1")
	self:loadNodeByName("nt_decorate_04")
end
function cityBuildFarm:updateViewModel5()
	self:loadNodeByName("nt_shuiqu_02")
	self:loadNodeByName("buildAnimationNormalType1_1")
	self:loadNodeByName("nt_decorate_05")
end
function cityBuildFarm:turnToHarvestView(animated)
	local viewModel = self:getViewModel()
	local turnToFunc = "turnToHarvestView" .. viewModel
	if self[turnToFunc] then
		self[turnToFunc](self, animated)
	end
end
function cityBuildFarm:turnToNormalView(animated)
	local viewModel = self:getViewModel()
	local turnToFunc = "turnToNormalView" .. viewModel
	if self[turnToFunc] then
		self[turnToFunc](self, animated)
	end
end
function cityBuildFarm:doTurnView(nameHide, nameShow, animated)
	if animated then
		local delayTime = cca.delay(0.4)
		local callFuncHide = cca.callFunc(function()
			local fadeOut = cca.fadeOut(0.8)
			if self[nameHide] then
				self[nameHide]:runAction(fadeOut)
			end
		end)
		local callFuncShow = cca.callFunc(function()
			self:removeNodeByName(nameHide)
			self:loadNodeByName(nameShow)
			self[nameShow]:setOpacity(0)
			local fadeIn = cca.fadeIn(0.8)
			self[nameShow]:runAction(fadeIn)
		end)
		_UPVALUE3_ = nil
		;(nil)[1] = callFuncHide
		;(nil)[2] = delayTime
		;(nil)[3] = callFuncShow
		local actSeq = cca.seq(nil)
		self:runAction(actSeq)
	else
		self:removeNodeByName(nameHide)
		self:loadNodeByName(nameShow)
	end
end
function cityBuildFarm:turnToHarvestView1(animated)
	local nameLvMiao = "nt_lvmiao"
	local nameMaizi = "nt_maizi_02"
	self:doTurnView(nameLvMiao, nameMaizi, animated)
end
function cityBuildFarm:turnToHarvestView2(animated)
	local nameLvMiao = "nt_lvmiao"
	local nameMaizi = "nt_maizi_02"
	self:doTurnView(nameLvMiao, nameMaizi, animated)
end
function cityBuildFarm:turnToHarvestView3(animated)
	local nameLvMiao = "nt_lvmiao"
	local nameMaizi = "nt_maizi_01"
	self:doTurnView(nameLvMiao, nameMaizi, animated)
end
function cityBuildFarm:turnToHarvestView4(animated)
	local nameLvMiao = "nt_lvmiao"
	local nameMaizi = "nt_maizi_01"
	self:doTurnView(nameLvMiao, nameMaizi, animated)
end
function cityBuildFarm:turnToHarvestView5(animated)
	local nameLvMiao = "nt_lvmiao"
	local nameMaizi = "nt_maizi_01"
	self:doTurnView(nameLvMiao, nameMaizi, animated)
end
function cityBuildFarm:turnToNormalView1(animated)
	local nameLvMiao = "nt_lvmiao"
	local nameMaizi = "nt_maizi_02"
	self:doTurnView(nameMaizi, nameLvMiao, animated)
end
function cityBuildFarm:turnToNormalView2(animated)
	local nameLvMiao = "nt_lvmiao"
	local nameMaizi = "nt_maizi_02"
	self:doTurnView(nameMaizi, nameLvMiao, animated)
end
function cityBuildFarm:turnToNormalView3(animated)
	local nameLvMiao = "nt_lvmiao"
	local nameMaizi = "nt_maizi_02"
	self:doTurnView(nameMaizi, nameLvMiao, animated)
end
function cityBuildFarm:turnToNormalView4(animated)
	local nameLvMiao = "nt_lvmiao"
	local nameMaizi = "nt_maizi_01"
	self:doTurnView(nameMaizi, nameLvMiao, animated)
end
function cityBuildFarm:turnToNormalView5(animated)
	local nameLvMiao = "nt_lvmiao"
	local nameMaizi = "nt_maizi_01"
	self:doTurnView(nameMaizi, nameLvMiao, animated)
end
return cityBuildFarm
