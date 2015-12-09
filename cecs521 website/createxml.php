<?php
$plat = $_POST['plat'];
$plng = $_POST['plng'];

$domDoc = new DOMDocument("1.0", "UTF-8");
$rootElt = $domDoc->createElement('location');
$rootNode = $domDoc->appendChild($rootElt);

$subElt = $domDoc->createElement('lat');
$attr = $domDoc->createAttribute('value');
$attrVal = $domDoc->createTextNode($plat);
$attr->appendChild($attrVal);
$subElt->appendChild($attr);
$subNode = $rootNode->appendChild($subElt);

$subElt2 = $domDoc->createElement('lng');
$attr2 = $domDoc->createAttribute('value');
$attrVal2 = $domDoc->createTextNode($plng);
$attr2->appendChild($attrVal2);
$subElt2->appendChild($attr2);
$subNode2 = $rootNode->appendChild($subElt2);


$domDoc->FormatOutput = true;
echo htmlentities($domDoc->saveXML());
$domDoc->save("dest.xml");
?>