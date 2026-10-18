// BIO 101 batch 3 - hand-set from OpenStax Biology 2e and Concepts of Biology. Plant structure and terminology, taxonomy, scientific method, cell chemistry.
const L = require('../sta/lib');
const { add, out } = L;
const T = {
  live: 'Characteristics of Living Things', sci: 'The Scientific Method', cell: 'The Cell Concept', euk: 'Eukaryotic Cell Structure', mic: 'Microbial Classification', fun: 'Fungi', alg: 'Algae', pro: 'Protozoa', vir: 'Viruses',
  term: 'Plant Terminologies', bry: 'Bryophytes', pter: 'Pteridophytes', tax: 'Taxonomy of Plants', sperm: 'Spermatophyta', ptis: 'Plant Tissues', ani: 'Animal Taxonomy', atis: 'Animal Tissues', ph: 'pH, Buffers and Membrane Transport', inorg: 'Inorganic Elements', org: 'Hydrocarbons and Organic Compounds', carb: 'Carbohydrates', mol: 'Biological Macromolecules',
};

// ---------------- scientific method and levels of organisation
add('A hypothesis in science must be:', 'Testable and capable of being shown false by evidence', ['A proven fact', 'A statement of personal belief', 'Impossible to test'], 'A hypothesis is a tentative explanation that can be tested by observation or experiment.', T.sci);
add('In a controlled experiment, the variable that the investigator deliberately changes is the:', 'Independent variable', ['Dependent variable', 'Control variable', 'Constant'], 'The dependent variable is what is measured in response.', T.sci);
add('The purpose of a control group in an experiment is to:', 'Provide a standard for comparison so the effect of the treatment can be judged', ['Receive the largest dose', 'Make the results look better', 'Reduce the number of organisms needed'], 'The control group is treated the same way except for the variable being tested.', T.sci);
add('A scientific theory differs from an everyday "theory" in that it:', 'Is a well-tested explanation supported by a large body of evidence', ['Is only a guess', 'Cannot be changed by new evidence', 'Has been tested only once'], 'Evolution and the cell theory are examples of scientific theories.', T.sci);
add('A student grows beans under red, green and blue light and measures the height of each plant after two weeks. The dependent variable is:', 'The height of the plants', ['The colour of the light', 'The number of seeds planted', 'The kind of bean used'], 'The colour of light is the independent variable and the height is what is measured.', T.sci);
add('Which of these is quantitative data?', 'The mass of a seed measured as 0.45 g', ['The seed is smooth', 'The leaf looks green', 'The root smells strong'], 'Quantitative data are numerical measurements, while the other options are descriptions.', T.sci);
add('The correct order of the levels of biological organisation from smallest to largest is:', 'Cell, tissue, organ, organ system, organism, population, community, ecosystem', ['Tissue, cell, organ, organism, organ system, population, ecosystem, community', 'Organ, tissue, cell, organism, organ system, community, population, ecosystem', 'Cell, organ, tissue, organ system, organism, ecosystem, community, population'], 'Each level is built from the one before it.', T.live);
add('The ability of a living thing to detect and react to changes in its surroundings is called:', 'Irritability (response to stimuli)', ['Excretion', 'Growth', 'Reproduction'], 'A plant shoot bending towards light is an example.', T.live);
add('The sum of all chemical reactions in an organism is its:', 'Metabolism', ['Homeostasis', 'Respiration only', 'Digestion'], 'Metabolism includes anabolism, which builds molecules, and catabolism, which breaks them down.', T.live);
add('Removal of the waste products of metabolism from the body is called:', 'Excretion', ['Egestion', 'Secretion', 'Ingestion'], 'Egestion is the removal of undigested food.', T.live);

// ---------------- plant terminologies: roots, stems, leaves, flowers
add('A root system with one main root that grows downwards and gives off smaller lateral roots is a:', 'Tap root system', ['Fibrous root system', 'Adventitious root system', 'Prop root system'], 'Dicots such as bean and mango have tap roots.', T.term);
add('Grasses and maize have a fibrous root system, which is made of:', 'Many roots of similar size arising from the base of the stem', ['One thick central root', 'Roots that grow only from leaves', 'Aerial roots only'], 'This system holds the soil firmly and is typical of monocots.', T.term);
add('Roots that arise from parts of the plant other than the radicle, such as the stem, are called:', 'Adventitious roots', ['Tap roots', 'Lateral roots', 'Primary roots'], 'Maize prop roots and the roots of a sweet potato cutting are adventitious.', T.term);
add('The prop roots of maize and the stilt roots of mangrove:', 'Give additional support to the plant', ['Store food', 'Carry out photosynthesis', 'Absorb gases from the air only'], 'They arise from the stem and grow into the soil.', T.term);
add('The swollen roots of carrot and cassava are modified for:', 'Storage of food', ['Support', 'Photosynthesis', 'Climbing'], 'They store carbohydrates for the plant\'s next growing season.', T.term);
add('Pneumatophores, as in mangrove, are roots that:', 'Grow upward out of waterlogged mud to take in air', ['Store water', 'Climb walls', 'Produce flowers'], 'They help the plant to get oxygen in oxygen-poor soil.', T.term);
add('The region of a root just behind the root cap where cells divide actively is the:', 'Region of cell division (meristematic zone)', ['Root hair zone', 'Region of maturation', 'Cortex'], 'Above it are the zones of elongation and maturation, where root hairs appear.', T.term);
add('Root hairs increase the absorption of water because they:', 'Increase the surface area of the root', ['Contain chlorophyll', 'Store starch', 'Make the root heavier'], 'Each root hair is an extension of an epidermal cell.', T.term);
add('The point on a stem where a leaf is attached is the:', 'Node', ['Internode', 'Axil', 'Petiole'], 'The part of the stem between two nodes is an internode.', T.term);
add('The angle between a leaf stalk and the stem is called the:', 'Axil', ['Node', 'Stipule', 'Lamina'], 'An axillary bud develops in the axil.', T.term);
add('The flat, broad, green part of a leaf is the:', 'Lamina (blade)', ['Petiole', 'Midrib', 'Stipule'], 'It is the main site of photosynthesis.', T.term);
add('A leaf in which the blade is divided into separate leaflets on a common axis is:', 'A compound leaf', ['A simple leaf', 'A needle leaf', 'A sessile leaf'], 'The rachis bears the leaflets, as in the flamboyant tree and cassia.', T.term);
add('A leaf that has no petiole and is attached directly to the stem is described as:', 'Sessile', ['Petiolate', 'Compound', 'Pinnate'], 'Petiolate leaves have a leaf stalk.', T.term);
add('Leaves of monocots such as maize and grasses typically show:', 'Parallel venation', ['Reticulate venation', 'Pinnate venation only', 'No veins'], 'Dicot leaves show net-like (reticulate) venation.', T.term);
add('The arrangement of leaves on a stem is called:', 'Phyllotaxy', ['Venation', 'Vernation', 'Inflorescence'], 'It may be alternate, opposite or whorled.', T.term);
add('When two leaves arise at each node on opposite sides of the stem, the phyllotaxy is:', 'Opposite', ['Alternate', 'Whorled', 'Spiral'], 'Guava shows opposite phyllotaxy, and hibiscus shows alternate.', T.term);
add('Three or more leaves arising at each node form a:', 'Whorl', ['Pair', 'Spiral', 'Rosette'], 'Alstonia (the devil tree) has leaves in whorls.', T.term);
add('Tendrils, as in the pumpkin plant, are modified:', 'Stems or leaves that help the plant to climb', ['Roots that store food', 'Flowers', 'Fruits'], 'They coil around a support.', T.term);
add('The thorns of Bougainvillea and the spines of cactus are modified to:', 'Protect the plant from herbivores', ['Store food', 'Absorb water', 'Produce seeds'], 'In cactus the spines are modified leaves that also reduce water loss.', T.term);
add('Irish potato tubers, ginger rhizomes and onion bulbs are all:', 'Underground modified stems that store food', ['Modified roots', 'Modified leaves only', 'Fruits'], 'They have nodes with buds, which shows that they are stems.', T.term);
add('Which of these is a rhizome?', 'Ginger', ['Carrot', 'Sweet potato', 'Radish'], 'A rhizome is a horizontal underground stem with nodes and buds.', T.term);
add('A flower arrangement in which many small flowers are borne on a common axis is an:', 'Inflorescence', ['Whorl', 'Corolla', 'Receptacle'], 'The sunflower head is an inflorescence of many florets.', T.term);
add('The male part of a flower, made up of the anther and filament, is the:', 'Stamen', ['Carpel', 'Pistil', 'Sepal'], 'The anther produces pollen grains.', T.term);
add('The female part of a flower consists of the:', 'Stigma, style and ovary', ['Anther and filament', 'Sepal and petal', 'Calyx and corolla'], 'Together they form the carpel or pistil.', T.term);
add('The collective name for all the petals of a flower is the:', 'Corolla', ['Calyx', 'Androecium', 'Gynoecium'], 'The calyx is made of the sepals.', T.term);
add('Transfer of pollen from an anther to a stigma is called:', 'Pollination', ['Fertilisation', 'Germination', 'Dispersal'], 'Fertilisation takes place after the pollen tube reaches the ovule.', T.term);
add('Which structure of a flower develops into the seed after fertilisation?', 'Ovule', ['Ovary wall', 'Stigma', 'Petal'], 'The ovary wall develops into the fruit.', T.term);
add('Wind-pollinated flowers are usually:', 'Small, with feathery stigmas and light pollen, and without bright petals or nectar', ['Large, brightly coloured and scented', 'Sticky and heavy with pollen', 'Enclosed within the bud'], 'Maize and grasses are wind-pollinated.', T.term);
add('Seeds that are dispersed by wind often have:', 'Wings or hairs that make them light', ['Hooks', 'A fleshy brightly coloured coat', 'A hard heavy shell'], 'The seeds of Tridax and dandelion have a parachute of hairs.', T.term);
add('Fruits with hooks, such as Bidens (black jack), are dispersed by:', 'Animals, through attachment to fur or clothes', ['Wind', 'Water', 'Explosion of the pod'], 'The hooks cling to passing animals.', T.term);
add('A seed has a testa, an embryo and food store. The part of the embryo that develops into the root is the:', 'Radicle', ['Plumule', 'Cotyledon', 'Hilum'], 'The plumule becomes the shoot.', T.term);
add('Germination in which the cotyledons are raised above the ground, as in the bean, is:', 'Epigeal germination', ['Hypogeal germination', 'Vivipary', 'Dormancy'], 'In hypogeal germination, as in maize and the broad bean, the cotyledons stay below ground.', T.term);
add('Which condition is NOT needed for the germination of most seeds?', 'Light', ['Water', 'Oxygen', 'Suitable temperature'], 'Most seeds germinate in darkness underground.', T.term);

// ---------------- plant structure and tissues, transport
add('The outer layer of cells of a young stem or root is the:', 'Epidermis', ['Cortex', 'Pith', 'Endodermis'], 'It protects the plant and in leaves is covered by a waxy cuticle.', T.ptis);
add('The waxy cuticle on the leaf surface reduces:', 'Water loss by evaporation', ['The uptake of mineral salts', 'The rate of photosynthesis in the dark', 'The number of stomata'], 'It makes the leaf surface waterproof.', T.ptis);
add('In the leaf, most photosynthesis occurs in the:', 'Palisade mesophyll', ['Upper epidermis', 'Spongy mesophyll only', 'Xylem'], 'Palisade cells are tightly packed below the upper epidermis and have many chloroplasts.', T.ptis);
add('The spongy mesophyll of a leaf has large air spaces that:', 'Allow gases to diffuse through the leaf', ['Store starch', 'Transport water', 'Support the leaf'], 'The air spaces connect with the stomata.', T.ptis);
add('Water loss from the aerial parts of a plant as water vapour is called:', 'Transpiration', ['Guttation', 'Translocation', 'Respiration'], 'Most of it occurs through the stomata.', T.ptis);
add('Which factor INCREASES the rate of transpiration?', 'High temperature and low humidity', ['Low temperature', 'High humidity', 'Still, cool air'], 'Faster evaporation and a steeper diffusion gradient increase water loss.', T.ptis);
add('Stomata open when the guard cells:', 'Absorb water and become turgid', ['Lose water and become flaccid', 'Divide', 'Produce starch only'], 'The thin inner walls of guard cells stretch less than the thick outer walls, which opens the pore.', T.ptis);
add('Movement of sugars from the leaves to other parts of the plant is called:', 'Translocation', ['Transpiration', 'Osmosis', 'Absorption'], 'It takes place in the phloem.', T.ptis);
add('The ring of cells in the root that controls the movement of water into the xylem is the:', 'Endodermis', ['Epidermis', 'Cortex', 'Pericycle'], 'The Casparian strip makes water pass through the cell membranes.', T.ptis);
add('In a dicot stem the vascular bundles are:', 'Arranged in a ring', ['Scattered throughout', 'Absent', 'Found only at the centre'], 'In monocot stems the bundles are scattered.', T.ptis);
add('Annual rings in a tree trunk are formed by:', 'Seasonal activity of the vascular cambium', ['Cork cambium only', 'Leaf fall', 'Root growth'], 'Wide pale xylem forms in the wet season and narrow dark xylem in the dry season.', T.ptis);
add('The cells of the xylem are strengthened by:', 'Lignin', ['Cellulose only', 'Chitin', 'Suberin only'], 'Lignin makes xylem rigid and waterproof.', T.ptis);
add('Sieve tube elements of the phloem are helped by:', 'Companion cells', ['Guard cells', 'Tracheids', 'Fibres'], 'Companion cells supply the energy for loading sugars.', T.ptis);
add('Cork (phellem) in the bark of old stems is:', 'Dead tissue that protects the stem and reduces water loss', ['Living tissue that carries sugar', 'The main water-conducting tissue', 'Tissue that makes leaves'], 'Cork cell walls contain suberin.', T.ptis);
add('Lenticels are small openings in the bark that allow:', 'Gas exchange', ['Absorption of minerals', 'Release of seeds', 'Water uptake'], 'They are found on woody stems.', T.ptis);

// ---------------- taxonomy of plants and classification
add('The study of the classification of living organisms is called:', 'Taxonomy', ['Ecology', 'Anatomy', 'Genetics'], 'It includes naming, describing and grouping organisms.', T.tax);
add('The scientist who introduced the binomial system of naming organisms is:', 'Carolus Linnaeus', ['Charles Darwin', 'Gregor Mendel', 'Louis Pasteur'], 'Each organism is given a genus name and a species name.', T.tax);
add('Which of these is a correctly written scientific name?', 'Zea mays', ['zea Mays', 'Zea Mays', 'ZEA MAYS'], 'The genus begins with a capital letter, the species begins with a lower-case letter, and both are italicised or underlined.', T.tax);
add('Organisms in the same genus must also belong to the same:', 'Family', ['Species', 'Population', 'Variety only'], 'Each rank includes all lower ranks beneath it.', T.tax);
add('Plants that have flowers and enclose their seeds in fruits belong to the division:', 'Angiospermae (Magnoliophyta)', ['Bryophyta', 'Pteridophyta', 'Coniferophyta'], 'They are the largest group of living plants.', T.tax);
add('Which characteristic is used to separate monocots from dicots?', 'Number of cotyledons in the seed', ['Colour of the flower', 'Presence of chlorophyll', 'Presence of roots'], 'Monocots have one cotyledon and dicots have two.', T.tax);
add('Fruit and vegetable crops such as maize, rice and wheat belong to the family:', 'Poaceae (grasses)', ['Fabaceae (legumes)', 'Solanaceae', 'Cucurbitaceae'], 'Their fruits are grains, called caryopses.', T.tax);
add('Beans, groundnut and cowpea belong to the family:', 'Fabaceae (Leguminosae)', ['Poaceae', 'Euphorbiaceae', 'Rutaceae'], 'Their roots carry nodules that contain nitrogen-fixing bacteria.', T.tax);
add('Tomato, pepper and Irish potato belong to the family:', 'Solanaceae', ['Fabaceae', 'Poaceae', 'Malvaceae'], 'They have flowers with five fused petals.', T.tax);
add('Cycads and pines are placed in the gymnosperms because they:', 'Produce seeds that are not enclosed in an ovary', ['Do not produce seeds', 'Have flowers with petals', 'Reproduce by spores only'], 'Their seeds are borne on the surface of cone scales.', T.sperm);
add('The male cones of a pine produce:', 'Pollen grains', ['Ovules', 'Spores of ferns', 'Fruits'], 'The female cones bear the ovules.', T.sperm);
add('Plants such as Selaginella and Lycopodium are called:', 'Club mosses (lycophytes)', ['Mosses', 'Liverworts', 'Cycads'], 'They are seedless vascular plants.', T.pter);
add('The horsetail Equisetum is distinguished by:', 'Jointed, ridged stems with whorls of tiny leaves', ['Large flowers', 'Cones that bear seeds', 'Rhizoids and no stem'], 'It is a seedless vascular plant containing silica in its stems.', T.pter);
add('A fern leaf is also called a:', 'Frond', ['Thallus', 'Tendril', 'Phyllode'], 'Young fronds are coiled, forming fiddleheads.', T.pter);
add('Thallus is the term for a plant body that:', 'Is not differentiated into root, stem and leaf', ['Has true roots', 'Has flowers', 'Produces seeds'], 'Liverworts and many algae have a thallus.', T.bry);
add('In the moss life cycle, the capsule is part of the:', 'Sporophyte', ['Gametophyte', 'Protonema', 'Rhizoid'], 'Meiosis in the capsule produces haploid spores.', T.bry);
add('Mosses play an important role in nature because they:', 'Hold water and help to form soil on bare ground', ['Produce seeds', 'Fix atmospheric nitrogen in nodules', 'Are the main source of timber'], 'They are pioneers in ecological succession.', T.bry);

// ---------------- animals: more on the groups
add('Which phylum has a body made of segments, a closed circulatory system and bristles called chaetae?', 'Annelida', ['Nematoda', 'Mollusca', 'Platyhelminthes'], 'The earthworm is a typical annelid.', T.ani);
add('Roundworms such as Ascaris and hookworm belong to:', 'Nematoda', ['Annelida', 'Platyhelminthes', 'Cnidaria'], 'They are unsegmented with a complete digestive tract.', T.ani);
add('The class of vertebrates whose members have feathers is:', 'Aves', ['Reptilia', 'Mammalia', 'Amphibia'], 'Birds also lay hard-shelled eggs and are endothermic.', T.ani);
add('Animals in the class Mammalia are characterised by:', 'Hair and mammary glands that produce milk', ['Feathers', 'Moist skin without scales', 'Gills throughout life'], 'Most mammals also give birth to live young.', T.ani);
add('Frogs, toads and newts belong to the class:', 'Amphibia', ['Reptilia', 'Pisces', 'Aves'], 'Amphibians typically have a larval stage in water and an adult stage on land.', T.ani);
add('Snakes, lizards and crocodiles are:', 'Reptiles', ['Amphibians', 'Mammals', 'Fish'], 'They have dry scaly skin and lay eggs with leathery shells.', T.ani);
add('Fish breathe by means of:', 'Gills', ['Lungs', 'Book lungs', 'Tracheae'], 'Gills have a large surface area and a rich blood supply.', T.ani);
add('An animal with a backbone is a:', 'Vertebrate', ['Invertebrate', 'Arthropod', 'Mollusc'], 'Fish, amphibians, reptiles, birds and mammals are vertebrates.', T.ani);
add('The exoskeleton of arthropods is made of:', 'Chitin', ['Cellulose', 'Keratin only', 'Calcium phosphate'], 'It must be shed (moulting) for the animal to grow.', T.ani);
add('Spiders differ from insects in having:', 'Eight legs and two body regions', ['Six legs and three body regions', 'Four legs', 'No legs'], 'Spiders are arachnids.', T.ani);
add('Animals that maintain a constant body temperature independent of the environment are called:', 'Endotherms (warm-blooded)', ['Ectotherms', 'Poikilotherms', 'Hibernators only'], 'Birds and mammals are endothermic.', T.ani);
add('Bilateral symmetry means that:', 'The body can be divided into two mirror-image halves along one plane only', ['The body can be divided in any plane through the centre', 'The animal has no definite shape', 'The body has no head'], 'Humans, fish and insects are bilaterally symmetrical.', T.ani);
add('Animals whose body cavity is lined completely by mesoderm are called:', 'Coelomates', ['Acoelomates', 'Pseudocoelomates', 'Diploblasts'], 'Annelids, molluscs, arthropods and vertebrates are coelomate.', T.ani);

// ---------------- inorganic elements and biological compounds
add('Which mineral element is part of the chlorophyll molecule?', 'Magnesium', ['Iron', 'Calcium', 'Sodium'], 'Plants with magnesium deficiency show yellowing between the veins.', T.inorg);
add('Iron is needed by animals for the synthesis of:', 'Haemoglobin', ['Chlorophyll', 'Insulin', 'Cellulose'], 'Lack of iron causes anaemia.', T.inorg);
add('Calcium is important in animals mainly for:', 'Bones, teeth and blood clotting', ['Making haemoglobin', 'Making thyroxine', 'Making ATP'], 'It is also needed for muscle contraction.', T.inorg);
add('Iodine is required for making:', 'Thyroxine', ['Insulin', 'Adrenaline', 'Haemoglobin'], 'Iodine deficiency can cause goitre.', T.inorg);
add('Nitrogen is an essential element for plants because it is a component of:', 'Proteins and nucleic acids', ['Cellulose only', 'Fats only', 'Water'], 'Nitrogen deficiency makes older leaves turn yellow.', T.inorg);
add('Phosphorus is a component of:', 'ATP, DNA and phospholipids', ['Chlorophyll', 'Cellulose', 'Starch'], 'It is also needed for strong root growth.', T.inorg);
add('Elements that are needed by plants in large quantities, such as nitrogen, phosphorus and potassium, are the:', 'Macronutrients', ['Micronutrients', 'Trace elements', 'Vitamins'], 'Trace elements such as zinc and boron are needed in very small amounts.', T.inorg);
add('Water is a good solvent for ionic substances because it is:', 'A polar molecule', ['A non-polar molecule', 'A very large molecule', 'A gas at body temperature'], 'The partial charges of water attract ions and polar molecules.', T.inorg);
add('The high specific heat capacity of water is important because it:', 'Helps organisms to avoid rapid changes in temperature', ['Makes water freeze at a high temperature', 'Allows water to dissolve fats', 'Makes ice denser than water'], 'A large amount of heat is needed to raise the temperature of water.', T.inorg);
add('Hydrogen bonds between water molecules are responsible for:', 'Cohesion and surface tension', ['Making water a gas', 'Breaking glycosidic bonds', 'Making water non-polar'], 'Cohesion helps water to move up the xylem.', T.inorg);
add('The element found in all organic compounds is:', 'Carbon', ['Nitrogen', 'Calcium', 'Sulphur'], 'Carbon forms four covalent bonds and long chains.', T.org);
add('A hydrocarbon contains:', 'Hydrogen and carbon only', ['Carbon and oxygen only', 'Hydrogen and oxygen only', 'Carbon, hydrogen and nitrogen'], 'Methane and ethane are examples.', T.org);
add('Compounds with the same molecular formula but different structural formulae are:', 'Isomers', ['Isotopes', 'Polymers', 'Allotropes'], 'Glucose and fructose are structural isomers, C6H12O6.', T.org);
add('The molecular formula of glucose is:', 'C6H12O6', ['C12H22O11', 'C6H10O5', 'C2H5OH'], 'Sucrose is C12H22O11.', T.carb);
add('Alcohols contain the functional group:', '-OH', ['-COOH', '-NH2', '-CHO'], 'Ethanol is C2H5OH.', T.org);
add('Which polysaccharide is the main component of insect exoskeletons and fungal cell walls?', 'Chitin', ['Cellulose', 'Starch', 'Glycogen'], 'It is a polymer of N-acetylglucosamine.', T.carb);
add('The test for proteins uses:', 'Biuret reagent, which turns purple', ['Iodine, which turns blue-black', 'Benedict\'s solution, which turns red', 'Sudan III, which turns red'], 'Copper(II) ions react with peptide bonds.', T.mol);
add('Ethanol emulsion test: a cloudy white emulsion shows the presence of:', 'Lipids', ['Proteins', 'Starch', 'Reducing sugars'], 'Lipids are insoluble in water and form an emulsion when the ethanol solution is poured into water.', T.mol);
add('The monomers of proteins are:', 'Amino acids', ['Nucleotides', 'Fatty acids', 'Monosaccharides'], 'There are 20 amino acids used in proteins.', T.mol);
add('Enzymes are:', 'Biological catalysts made of protein', ['Hormones made of lipid', 'Carbohydrates that store energy', 'Nucleic acids that carry genes'], 'They are specific to their substrates.', T.mol);
add('An enzyme stops working when it is heated to a high temperature because:', 'Its shape (active site) is changed, which denatures it', ['It is digested by other enzymes', 'It changes into a carbohydrate', 'The substrate becomes a gas'], 'The bonds that hold the tertiary structure are broken.', T.mol);
add('The vitamin whose deficiency causes scurvy is:', 'Vitamin C', ['Vitamin A', 'Vitamin D', 'Vitamin K'], 'Citrus fruits are a good source.', T.mol);

module.exports = out;
