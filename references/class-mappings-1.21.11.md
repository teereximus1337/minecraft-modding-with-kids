# Minecraft 1.21.11 Mojang Official Mappings — Definitive Class Reference

Extracted from decompiled 1.21.11 sources. These are the ONLY correct class names.
AI training data contains outdated names — ALWAYS verify against this file.

## CRITICAL: Classes that were REMOVED or RENAMED in 1.21.11

| Old Name (WRONG) | Replacement | Notes |
|---|---|---|
| `SwordItem` | `Item` with `.sword()` on Properties | No more SwordItem class |
| `TieredItem` | `Item` with tool Properties methods | No more TieredItem class |
| `DiggerItem` | `Item` with tool Properties methods | No more DiggerItem class |
| `ResourceLocation` | `net.minecraft.resources.Identifier` | Renamed in 1.21.x |
| `Item.Settings` | `Item.Properties` | Mojang mapping name |
| `World` / `ServerWorld` | `Level` / `ServerLevel` | Mojang mapping names |
| `StatusEffect` / `StatusEffects` | `MobEffect` / `MobEffects` | Mojang mapping names |
| `StatusEffectInstance` | `MobEffectInstance` | Mojang mapping name |
| `SoundCategory` | `SoundSource` | Mojang mapping name |
| `Registries` (yarn) | `BuiltInRegistries` (for registry instances) | Different meaning in Mojang |

## Item System (net.minecraft.world.item.*)

### Creating Items

Swords, tools, and weapons no longer have dedicated classes. Use `Item` directly:

```java
// Sword: use Item with .sword() on Properties
public static final Item MY_SWORD = register("my_sword", MyCustomSword::new,
    new Item.Properties().sword(ToolMaterial.DIAMOND, 5f, -2.4f));

// Pickaxe: use Item with .pickaxe() on Properties
public static final Item MY_PICK = register("my_pick", Item::new,
    new Item.Properties().pickaxe(ToolMaterial.IRON, 1f, -2.8f));

// Axe: use .axe(), Shovel: use .shovel(), Hoe: use .hoe()
```

### Properties Methods for Tools

```java
Item.Properties.sword(ToolMaterial, float attackDamage, float attackSpeed)
Item.Properties.pickaxe(ToolMaterial, float attackDamage, float attackSpeed)
Item.Properties.axe(ToolMaterial, float attackDamage, float attackSpeed)
Item.Properties.shovel(ToolMaterial, float attackDamage, float attackSpeed)
Item.Properties.hoe(ToolMaterial, float attackDamage, float attackSpeed)
```

### Overridable Item Methods (from Item.java)

```java
// Called when hitting an entity — VOID return type, not boolean!
public void hurtEnemy(ItemStack stack, LivingEntity target, LivingEntity attacker)

// Called after hurtEnemy
public void postHurtEnemy(ItemStack stack, LivingEntity target, LivingEntity attacker)

// Right-click in air
public InteractionResult use(Level level, Player player, InteractionHand hand)

// Right-click on a block
public InteractionResult useOn(UseOnContext context)

// Called every tick while item is in inventory
public void inventoryTick(ItemStack stack, Level level, Entity entity, int slot, boolean selected)

// Mining a block
public boolean mineBlock(ItemStack stack, Level level, BlockState state, BlockPos pos, LivingEntity miner)

// Custom tooltip lines
public void appendHoverText(ItemStack stack, TooltipContext ctx, TooltipDisplay display, Consumer<Component> textConsumer, TooltipFlag flag)

// Eating/drinking finished
public ItemStack finishUsingItem(ItemStack stack, Level level, LivingEntity entity)

// Glow effect (enchanted look)
public boolean isFoil(ItemStack stack)
```

### ToolMaterial Constants

```java
ToolMaterial.WOOD
ToolMaterial.STONE
ToolMaterial.IRON
ToolMaterial.DIAMOND
ToolMaterial.NETHERITE
ToolMaterial.GOLD
```

## Item Registration Pattern (1.21.11 Fabric)

```java
import net.minecraft.core.Registry;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.core.registries.Registries;
import net.minecraft.resources.Identifier;
import net.minecraft.resources.ResourceKey;
import net.minecraft.world.item.Item;
import java.util.function.Function;

public static <T extends Item> T register(String name, Function<Item.Properties, T> factory, Item.Properties properties) {
    ResourceKey<Item> key = ResourceKey.create(Registries.ITEM, Identifier.fromNamespaceAndPath(MOD_ID, name));
    T item = factory.apply(properties.setId(key));
    Registry.register(BuiltInRegistries.ITEM, key, item);
    return item;
}
```

## Creative Tab Registration (Fabric API)

```java
import net.fabricmc.fabric.api.itemgroup.v1.ItemGroupEvents;
import net.minecraft.world.item.CreativeModeTabs;

ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.COMBAT)
    .register((entries) -> entries.accept(MY_SWORD));
```

## Entity Classes (net.minecraft.world.entity.*)

| Class | Package |
|---|---|
| Entity | net.minecraft.world.entity.Entity |
| LivingEntity | net.minecraft.world.entity.LivingEntity |
| Player | net.minecraft.world.entity.player.Player |
| Mob | net.minecraft.world.entity.Mob |
| LightningBolt | net.minecraft.world.entity.LightningBolt |
| EntityType | net.minecraft.world.entity.EntityType |

## Effects (net.minecraft.world.effect.*)

| Class | Package |
|---|---|
| MobEffect | net.minecraft.world.effect.MobEffect |
| MobEffects | net.minecraft.world.effect.MobEffects |
| MobEffectInstance | net.minecraft.world.effect.MobEffectInstance |

## Sound & Particles

| Class | Package |
|---|---|
| SoundEvents | net.minecraft.sounds.SoundEvents |
| SoundSource | net.minecraft.sounds.SoundSource |
| ParticleTypes | net.minecraft.core.particles.ParticleTypes |

## World/Level

| Class | Package |
|---|---|
| Level | net.minecraft.world.level.Level |
| ServerLevel | net.minecraft.server.level.ServerLevel |
| BlockPos | net.minecraft.core.BlockPos |

## Interaction

| Class | Package |
|---|---|
| InteractionResult | net.minecraft.world.InteractionResult |
| InteractionHand | net.minecraft.world.InteractionHand |

## Registry

| Class | Package |
|---|---|
| Registry | net.minecraft.core.Registry |
| BuiltInRegistries | net.minecraft.core.registries.BuiltInRegistries |
| Registries | net.minecraft.core.registries.Registries |
| ResourceKey | net.minecraft.resources.ResourceKey |
| Identifier | net.minecraft.resources.Identifier |
