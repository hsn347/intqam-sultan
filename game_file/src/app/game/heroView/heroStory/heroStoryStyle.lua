local heroBiographyRead = include("heroBiographyRead")
local heroBiographyCtrl = SoraDGetCtrl("heroBiographyCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroStoryStyle = class("heroStoryStyle", function(ccsFileName)
	local target = cc.CSLoader:createNode(getCCSPath(ccsFileName))
	target.ccsFileName = ccsFileName
	return target
end)
function heroStoryStyle:ctor()
	self.spineList, _UPVALUE0_ = nil, nil
end
function heroStoryStyle:setNoAct(spine)
	spine:setAnimation(0, "animation", false)
	spine:clearTrack(0)
end
function heroStoryStyle:setActiveModel(spine, isUsm)
	spine:setColor(cc.c3b(255, 255, 255))
	if isUsm then
		spine:start()
	else
		spine:clearTracks()
		spine:setAnimation(0, "animation", true)
	end
end
function heroStoryStyle:setNotActiveModel(spine, isUsm)
	spine:setColor(cc.c3b(255, 255, 255))
	if isUsm then
		spine:pause()
	else
		spine:clearTracks()
		self:setNoAct(spine)
	end
end
function heroStoryStyle:setNotOwnModel(spine, isUsm)
	spine:setColor(cc.c3b(100, 100, 100))
	if isUsm then
		spine:pause()
	else
		spine:clearTracks()
		self:setNoAct(spine)
	end
end
function heroStoryStyle:setImgHYClick(target, heroID)
	target:setPreciseTouchEnabled(true)
	target:setTouchEnabled(true)
	target:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			SoraDPlaySound()
			if heroCtrl:getHeroInfoByID(heroID) then
				SoraDRemoveAllPrePanelFromManager(self.parent)
				SoraDShowHeroDetailView(heroID)
			else
				local itemNum, needNum, itemID, isEnough = heroltCtrl:judgeUpgradeItem(heroID)
				if isEnough then
					local panel = SoraDSearchPanelFromManagerByName("newHeroListView")
					if panel then
						panel:jumpToUnlockHero(heroID)
						self.parent:removeFromParent()
					else
						SoraDRemoveAllPrePanelFromManager(self.parent)
						local panel = uiManager:show("newHeroListView").view
						panel:jumpToUnlockHero(heroID)
					end
				else
					_ENV = panel
					panel.itemID = itemID
					panel.needCount = needNum
					panel.noExchange = true
					uiManager:show("newHeroGainChipMethodView", panel)
				end
			end
		end
	end)
end
function heroStoryStyle:initStyle(index, parent)
	self.parent = parent
	local heroList = heroBiographyRead.getHeroListByStoryIndex(index)
	local status = heroBiographyCtrl:getHeroStoryStatus(index)
	for k, v in ipairs(heroList) do
		local spineNode = SoraDGetChildByName(self, "Node_spine_" .. k)
		if spineNode then
			local image_hy = SoraDGetChildByName(spineNode, "Image_hy")
			local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(v)
			local isUsm = cfg.isUsm or false
			local spine
			if isUsm then
				spine = cc.criSprite.createCriSprite(spineCfg, false, true, function(criSp)
					criSp:start()
					if status == gHeroStoryUnLockType.ACTIVED then
						self:setActiveModel(spine, isUsm)
					elseif status == gHeroStoryUnLockType.UNLOCK then
						self:setNotActiveModel(spine, isUsm)
					elseif heroCtrl:getHeroInfoByID(v) then
						self:setNotActiveModel(spine, isUsm)
					else
						self:setNotOwnModel(spine, isUsm)
					end
				end)
				spine:setAnchorPoint(cc.p(0.5, 0))
				spine:setScale(cfg.binary[1])
				spine:setPosition(cfg.binary[2], cfg.binary[3])
				spine:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
				spine:addTo(spineNode, -1)
			else
				local atlas = string.gsub(spineCfg, "%.%w+$", ".atlas")
				spine = sp.SkeletonAnimation:create(spineCfg, atlas, cfg.binary[1])
				spine:setPosition(cfg.binary[2], cfg.binary[3])
				spine:setAnimation(0, "animation", true)
				spine:addTo(spineNode, -1)
				if status == gHeroStoryUnLockType.ACTIVED then
					self:setActiveModel(spine, isUsm)
				elseif status == gHeroStoryUnLockType.UNLOCK then
					self:setNotActiveModel(spine, isUsm)
				elseif heroCtrl:getHeroInfoByID(v) then
					self:setNotActiveModel(spine, isUsm)
				else
					self:setNotOwnModel(spine, isUsm)
				end
			end
			table.insert(self.spineList, spine)
			image_hy:setOpacity(2.5500000000000003)
			self:setImgHYClick(image_hy, v)
		end
	end
end
function heroStoryStyle:updateStyle(index)
	local heroList = heroBiographyRead.getHeroListByStoryIndex(index)
	local status = heroBiographyCtrl:getHeroStoryStatus(index)
	for i, spine in ipairs(self.spineList) do
		local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(heroList[i])
		local isUsm = cfg.isUsm or false
		if status == gHeroStoryUnLockType.ACTIVED then
			self:setActiveModel(spine, isUsm)
		elseif status == gHeroStoryUnLockType.UNLOCK then
			self:setNotActiveModel(spine, isUsm)
		elseif heroCtrl:getHeroInfoByID(heroList[i]) then
			self:setNotActiveModel(spine, isUsm)
		else
			self:setNotOwnModel(spine, isUsm)
		end
	end
end
return heroStoryStyle
