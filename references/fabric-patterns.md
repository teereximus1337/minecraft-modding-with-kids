# Fabric 1.21.11 Code Patterns

Correct, tested patterns for Minecraft 1.21.11 with Mojang Official Mappings.
ALWAYS use these instead of patterns from AI training data.

## Item Registration

```java
import net.minecraft.core.Registry;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.core.registries.Registries;
import net.minecraft.resources.Identifier;
import net.minecraft.resources.ResourceKey;
import net.minecraft.world.item.Item;
import java.util.function.Function;

public class ModItems {
    public static final Item MY_ITEM = register("my_item", MyItem::new,
        new Item.Properties().durability(1561).stacksTo(1));

    public static <T extends Item> T register(String name, Function<Item.Properties, T> factory, Item.Properties props) {
        ResourceKey<Item> key = ResourceKey.create(Registries.ITEM,
            Identifier.fromNamespaceAndPath(MOD_ID, name));
        T item = factory.apply(props.setId(key));
        Registry.register(BuiltInRegistries.ITEM, key, item);
        return item;
    }

    public static void initialize() {
        // Creative tab registration here
        ItemGroupEvents.modifyEntriesEvent(CreativeModeTabs.COMBAT)
            .register((entries) -> entries.accept(MY_ITEM));
    }
}
```

## Block Registration

```java
import net.minecraft.world.level.block.Block;
import net.minecraft.world.level.block.state.BlockBehaviour;
import net.minecraft.world.level.block.SoundType;

public class ModBlocks {
    public static final Block MY_BLOCK = register("my_block",
        new MyBlock(BlockBehaviour.Properties.of()
            .strength(0.5f)
            .sound(SoundType.WOOD)
            .noOcclusion()  // Required for non-full-cube blocks
            .setId(ResourceKey.create(Registries.BLOCK,
                Identifier.fromNamespaceAndPath(MOD_ID, "my_block")))));

    private static Block register(String name, Block block) {
        return Registry.register(BuiltInRegistries.BLOCK,
            Identifier.fromNamespaceAndPath(MOD_ID, name), block);
    }

    public static void initialize() {}
}
```

BlockItem registration (so the block can be held/placed):
```java
// In ModItems.java
public static final Item MY_BLOCK_ITEM = register("my_block",
    props -> new BlockItem(ModBlocks.MY_BLOCK, props),
    new Item.Properties());
```

## Block Interactions

Override BOTH methods so it works whether the player is holding an item or not:

```java
// Right-click with empty hand
@Override
protected InteractionResult useWithoutItem(BlockState state, Level level,
        BlockPos pos, Player player, BlockHitResult hit) {
    doSomething(level, pos);
    return InteractionResult.SUCCESS;
}

// Right-click while holding any item
@Override
protected InteractionResult useItemOn(ItemStack stack, BlockState state,
        Level level, BlockPos pos, Player player, InteractionHand hand,
        BlockHitResult hit) {
    doSomething(level, pos);
    return InteractionResult.SUCCESS;
}
```

## Custom Block Shapes

```java
import net.minecraft.world.phys.shapes.VoxelShape;

// In your Block class:
private final VoxelShape shape;

// Values are 0-16 (sixteenths of a block): from_x, from_y, from_z, to_x, to_y, to_z
private static final VoxelShape HALF_HEIGHT = Block.box(0, 0, 0, 16, 8, 16);

@Override
protected VoxelShape getShape(BlockState state, BlockGetter level,
        BlockPos pos, CollisionContext ctx) {
    return shape;
}
```

## Custom Sounds

### 1. Place .ogg files in:
`src/main/resources/assets/<modid>/sounds/`

### 2. Create sounds.json:
`src/main/resources/assets/<modid>/sounds.json`
```json
{
    "my_sound": {
        "sounds": ["<modid>:my_sound_file"]
    }
}
```

### 3. Register in Java:
```java
private static SoundEvent registerSound(String name) {
    Identifier id = Identifier.fromNamespaceAndPath(MOD_ID, name);
    SoundEvent event = SoundEvent.createVariableRangeEvent(id);
    Registry.register(BuiltInRegistries.SOUND_EVENT, id, event);
    return event;
}
```

### 4. Play the sound:
```java
level.playSound(null, pos, soundEvent, SoundSource.BLOCKS, 3.0f, 1.0f);
```

## Item Methods: Correct Signatures

```java
// Hit a mob (VOID, not boolean!)
public void hurtEnemy(ItemStack stack, LivingEntity target, LivingEntity attacker)

// Inventory tick (note: ServerLevel, not Level; EquipmentSlot, not int+boolean)
public void inventoryTick(ItemStack stack, ServerLevel level, Entity entity,
    @Nullable EquipmentSlot slot)

// Check if player is holding this item (don't rely on slot parameter):
if (player.getMainHandItem() != stack) return;
```

## Creative Mode Gotchas

- `use()` and `useOn()` on Items DO NOT FIRE in creative mode for non-block items
- `hurtEnemy()` DOES fire in creative mode (use for melee triggers)
- `inventoryTick()` DOES fire in creative mode (use for hold-to-activate mechanics)
- Block interactions (`useWithoutItem`, `useItemOn`) DO work in creative mode
- Detect crouch with `player.isShiftKeyDown()` for hold-to-activate features

## Required Files for New Items

Every new item needs ALL of these:
1. Java class: `src/main/java/<package>/item/MyItem.java`
2. Registration: add to `ModItems.java`
3. Item model: `assets/<modid>/models/item/my_item.json`
4. Client item def: `assets/<modid>/items/my_item.json`
5. Lang entry: add to `assets/<modid>/lang/en_us.json`
6. Texture: `assets/<modid>/textures/item/my_item.png` (16x16)

## Required Files for New Blocks

1. Java class: `src/main/java/<package>/block/MyBlock.java`
2. Block registration: add to `ModBlocks.java`
3. BlockItem registration: add to `ModItems.java`
4. Block state: `assets/<modid>/blockstates/my_block.json`
5. Block model: `assets/<modid>/models/block/my_block.json`
6. Item model: `assets/<modid>/models/item/my_block.json` (usually parents to block model)
7. Client item def: `assets/<modid>/items/my_block.json`
8. Lang entry: add to `en_us.json`
9. Texture: `assets/<modid>/textures/block/my_block.png`
