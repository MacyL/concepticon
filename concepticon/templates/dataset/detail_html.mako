<%inherit file="../home_comp.mako"/>
<%namespace name="util" file="../util.mako"/>

<%block name="head">
    <script src="${request.static_url('concepticon:static/sigmajs/sigma.js')}"></script>
    <script src="${request.static_url('concepticon:static/sigmajs/plugins/sigma.parsers.json.min.js')}"></script>
    <script src="${request.static_url('concepticon:static/sigmajs/plugins/sigma.layout.forceAtlas2.min.js')}"></script>
    <script src="${request.static_url('concepticon:static/sigmajs/plugins/sigma.renderers.edgeLabels.min.js')}"></script>
    <script src="${request.static_url('concepticon:static/sigmajs/plugins/sigma.plugins.animate.min.js')}"></script>
    <script src="${request.static_url('concepticon:static/sigmajs/plugins/sigma.plugins.dragNodes.min.js')}"></script>
    <script src="${request.static_url('concepticon:static/sigmajs/plugins/sigma.layout.noverlap.js')}"></script>

    <style type="text/css">
        #container {
            max-width: 100%;
            height: 450px;
            margin: auto;
            margin-bottom: 1em;
        }
    </style>
</%block>

<%def name="sidebar()">
    <div style="text-align: center; margin: 1em 5em 1em 5em;">
        <img src="${request.static_url('concepticon:static/logo.png')}"/>
    </div>
    <%util:well title="Cite">
        ${h.newline2br(h.text_citation(request, ctx))|n}
        <p>
            <a href="http://dx.doi.org/10.5281/zenodo.51175">
                <img src="https://zenodo.org/badge/doi/10.5281/zenodo.51175.svg" alt="10.5281/zenodo.51175">
            </a>
        </p>
        ${h.cite_button(request, ctx)}
    </%util:well>
    <%util:well title="Version">
        <a href="${req.resource_url(req.dataset)}" style="font-family: monospace">concepticon.clld.org</a>
        serves the latest
        ${h.external_link('https://github.com/clld/concepticon-data/releases', label='released version')}
        of data curated at
        ${h.external_link('https://github.com/clld/concepticon-data', label='clld/concepticon-data')} -
        currently the
        ${h.external_link('https://github.com/clld/concepticon-data/releases/tag/v1.0.1', label='release 1.0.1')}
    </%util:well>
</%def>

<h2>Welcome to the Concepticon</h2>

<p class="lead">
    This resource presents an attempt to link the large amount of different concept lists
    which are used in the linguistic literature, ranging from
    ${h.external_link('http://en.wikipedia.org/wiki/Swadesh_List', label='Swadesh lists')}
    in historical linguistics to
    ${h.external_link('https://en.wikipedia.org/wiki/Boston_Naming_Test', label='naming tests')}
    in clinical studies and psycholinguistics.
</p>
<h3>A Resource for the Linking of Concept Lists</h3>
<div class="row-fluid">
  <div class="span5">
    <p class="lead">
    This resource, our Concepticon, links <a
	    href="${request.route_url('values')}">concept labels</a> from
    different <a href="{request.route_url('contributions')}">conceptlists</a>
    to <a href="${request.route_url('parameters')}">concept sets</a>.  Each
    concept set is given a unique identifier, a unique label, and a
    human-readable definition. Concept sets are further structured by defining
    different relations between the concepts, as you can see in the graphic to
    the right, which displays the relations between concept sets linked to the
    concept set <a href="${request.route_url('parameters')}/1640">SIBLING</a>. The
    resource can be used for various purposes. Serving as a rich reference for
    new and existing databases in diachronic and synchronic linguistics, it
    allows researchers a quick access to studies on semantic change,
    cross-linguistic polysemies, and semantic associations.
    </p>
  </div>
  <div id="container" class="span6"></div>
</div>
<div class="row-fluid">
<p class="lead">
    If you want to learn more about the ideas behind our Concepticon, have a look at our <a href="${request.route_url('about')}">about</a> page.
</p></div>



<script>
sigma.parsers.json(
    '${request.route_url("relations")}',
    {
      container: 'container',
      settings: {
        defaultNodeColor: '#006400',
        labelSize: 'fixed',
	defaultEdgeType: 'curve',
        edgeLabelSize: 'fixed',
        labelThreshold: 4,
        labelSizeRatio: 4,
        edgeLabelThreshold: 0.01,
        defaultLabelSize: 8,
        defaultEdgeLabelSize: 4,
        drawEdgeLabels: true,
        minEdgeSize: 1.25,
        maxEdgeSize: 1.25
      }
    },
    function(s) {
      for (var i=0,edge; edge=s.graph.edges()[i]; i++) {
        edge['color'] = '#222222';
	edge['arrow'] = 'source';
      }
      for (var i=0,node; node=s.graph.nodes()[i]; i++) {
	if (node['label'] == 'SIBLING') {
	  node['color'] = '#DC143C';
	  node['size'] = 1.5;
	}
      }
      var noverlapListener = s.configNoverlap({
        nodeMargin: 5,
        scaleNodes: 1.05,
        gridSize: 75,
        easing: 'quadraticInOut', 
        duration: 500  
      });
      // Bind the events:
      noverlapListener.bind('start stop interpolate', function(e) {
        console.log(e.type);
        if(e.type === 'start') {
          console.time('noverlap');
        }
        if(e.type === 'interpolate') {
          console.timeEnd('noverlap');
        }
      });
      s.startForceAtlas2();
      setTimeout(function() {s.killForceAtlas2();}, 1000);
      var dragListener = sigma.plugins.dragNodes(s, s.renderers[0]);
      dragListener.bind('startdrag', function(event) {
        console.log(event);
      });
      dragListener.bind('drag', function(event) {
        console.log(event);
      });
      dragListener.bind('drop', function(event) {
        console.log(event);
      });
      dragListener.bind('dragend', function(event) {
        console.log(event);
      });
    }
);
</script>
