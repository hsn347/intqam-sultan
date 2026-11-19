# -*- coding: utf-8 -*-
"""
tasks — حزمة مهام البوت المستقلة للعبة انتقام السلاطين
"""

from tasks.base_task import BaseTask, TaskResult, ConnectionCircuitBreakerError
from tasks.port import PortTask
from tasks.merchant_ship import MerchantShipTask
from tasks.treasure import TreasureTask
from tasks.city_harvest import CityHarvestTask
from tasks.train import TrainTask
from tasks.shield import ShieldTask
from tasks.research import ResearchTask
from tasks.flower import FlowerTask
from tasks.wonder_merchant import WonderMerchantTask
from tasks.imperial_mausoleum import ImperialMausoleumTask
from tasks.pet import PetTask
from tasks.material_synthesis import MaterialSynthesisTask
from tasks.forge_equipment import ForgeEquipmentTask
from tasks.cure_wounded import CureWoundedTask
from tasks.alliance import AllianceTask
from tasks.war_medal import WarMedalTask
from tasks.daily_train import DailyTrainTask
from tasks.building import BuildingTask
from tasks.arena import ArenaTask
from tasks.hero_trial import HeroTrialTask
from tasks.command_hall import CommandHallTask
from tasks.daily_quest import DailyQuestTask
from tasks.skills import SkillsTask
from tasks.material_workshop import MaterialWorkshopTask
from tasks.stamina import StaminaTask
from tasks.watermill import WatermillTask

__all__ = [
    "BaseTask",
    "TaskResult",
    "ConnectionCircuitBreakerError",
    "PortTask",
    "MerchantShipTask",
    "TreasureTask",
    "CityHarvestTask",
    "TrainTask",
    "DailyTrainTask",
    "BuildingTask",
    "ShieldTask",
    "ResearchTask",
    "FlowerTask",
    "WonderMerchantTask",
    "ImperialMausoleumTask",
    "PetTask",
    "MaterialSynthesisTask",
    "ForgeEquipmentTask",
    "CureWoundedTask",
    "AllianceTask",
    "WarMedalTask",
    "ArenaTask",
    "HeroTrialTask",
    "CommandHallTask",
    "DailyQuestTask",
    "SkillsTask",
    "MaterialWorkshopTask",
    "StaminaTask",
    "WatermillTask",
]
